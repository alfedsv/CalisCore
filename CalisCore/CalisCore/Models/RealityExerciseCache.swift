//
//  RealityExerciseCache.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 16.10.2026.
//

//
//  RealityExerciseCache.swift
//  CalisCore
//
//  Created by Alexander Fedoseev on 16.10.2026.
//

import Foundation
import RealityKit

/// Кеш загруженных RealityKit-сущностей (USDZ-моделей с анимациями).
///
/// Зачем нужен:
/// - Загрузка USDZ из бандла — дорогая операция (парсинг, текстуры,
///   подготовка скелета и анимаций). Кеш избавляет от фризов при показе.
/// - В кеше хранятся **шаблоны**. При показе клонируйте:
///   `entity.clone(recursive: true)`.
///
/// Особенности реализации:
/// - Потокобезопасен: все обращения к mutable-состоянию защищены `NSLock`
///   через `withLock` (scoped locking — совместимо со Swift 6).
/// - Не использует Combine.
/// - Все колбэки вызываются на главном потоке.
final class RealityExerciseCache {

    // MARK: - Errors

    enum LoadError: Error, CustomStringConvertible {
        case resourceNotFound(name: String)

        var description: String {
            switch self {
            case .resourceNotFound(let name):
                return "Ресурс \(name).usdz не найден в бандле"
            }
        }
    }

    // MARK: - Singleton

    static let shared = RealityExerciseCache()

    // MARK: - Storage

    /// Имя ресурса (без расширения) → загруженная сущность-шаблон.
    private var cache: [String: Entity] = [:]

    /// Мьютекс для `cache`, `isLoading` и `pendingCompletions`.
    /// Всегда используется через `withLock`, чтобы Swift 6 мог проверить
    /// безопасность в асинхронном контексте.
    private let lock = NSLock()

    /// Флаг «идёт загрузка» — предотвращает параллельные проходы по диску.
    private var isLoading = false

    /// Колбэки, накопленные за время текущей загрузки.
    private var pendingCompletions: [() -> Void] = []

    // MARK: - Init

    private init() {}

    // MARK: - Preload

    /// Предзагружает набор моделей по именам ресурсов.
    ///
    /// - Если все модели уже в кеше — колбэк вызывается сразу на главном потоке.
    /// - Если загрузка уже идёт — колбэк добавляется в очередь ожидания.
    /// - Иначе — недостающие модели грузятся в фоне.
    ///
    /// - Parameters:
    ///   - names: имена USDZ-ресурсов без расширения (например, `"pushup"`).
    ///   - completion: вызовется на главном потоке после завершения.
    func preload(names: Set<String>, completion: (() -> Void)? = nil) {
        // Шаг 1: определяем, чего не хватает, и решаем, нужна ли загрузка.
        let needsLoading: Bool = lock.withLock {
            let missing = names.filter { cache[$0] == nil }

            if missing.isEmpty {
                return false
            }

            if let completion = completion {
                pendingCompletions.append(completion)
            }

            if isLoading {
                return false
            }

            isLoading = true
            return true
        }

        guard needsLoading else {
            DispatchQueue.main.async { completion?() }
            return
        }

        // Шаг 2: фоновая загрузка. Лок держим только короткими блоками.
        Task { [weak self] in
            guard let self = self else { return }

            // Пересчитываем missing — состояние могло измениться,
            // пока планировщик не запустил Task.
            let missing: Set<String> = self.lock.withLock {
                Set(names.filter { self.cache[$0] == nil })
            }

            var loaded: [String: Entity] = [:]
            for name in missing {
                do {
                    let entity = try await Entity.loadFromBundle(named: name, in: .main)
                    loaded[name] = entity
                } catch {
                    print("❌ RealityKit: не удалось загрузить \(name): \(error)")
                }
            }

            // Шаг 3: публикуем результаты и забираем колбэки.
            let callbacks: [() -> Void] = self.lock.withLock {
                for (key, value) in loaded {
                    self.cache[key] = value
                }
                self.isLoading = false
                let cbs = self.pendingCompletions
                self.pendingCompletions.removeAll()
                return cbs
            }

            DispatchQueue.main.async {
                callbacks.forEach { $0() }
            }
        }
    }

    // MARK: - Lazy load

    /// Ленивая загрузка одной модели.
    ///
    /// - Если модель уже в кеше — колбэк вызывается сразу на главном потоке.
    /// - Иначе запускается асинхронная загрузка.
    ///
    /// - Parameters:
    ///   - name: имя USDZ-ресурса без расширения.
    ///   - completion: вызывается на главном потоке. Аргумент — шаблон
    ///     или `nil` при ошибке. **Не мутируйте** шаблон: клонируйте.
    func loadEntity(named name: String, completion: @escaping (Entity?) -> Void) {
        // Быстрая проверка кеша — синхронная, под `withLock`.
        if let cached = lock.withLock({ cache[name] }) {
            DispatchQueue.main.async { completion(cached) }
            return
        }

        Task { [weak self] in
            guard let self = self else { return }
            do {
                let entity = try await Entity.loadFromBundle(named: name, in: .main)

                self.lock.withLock {
                    self.cache[name] = entity
                }

                await MainActor.run { completion(entity) }
            } catch {
                print("❌ RealityKit: не удалось загрузить \(name): \(error)")
                await MainActor.run { completion(nil) }
            }
        }
    }

    // MARK: - Sync access

    /// Синхронно достаёт шаблон из кеша. **Без загрузки с диска.**
    ///
    /// - Note: Результат — шаблон. Для сцены клонируйте:
    ///   `entity.clone(recursive: true)`.
    func entity(named name: String) -> Entity? {
        lock.withLock { cache[name] }
    }

    // MARK: - Manual cache control

    /// Полностью очищает кеш.
    func clear() {
        lock.withLock {
            cache.removeAll()
            pendingCompletions.removeAll()
        }
    }

    /// Убирает из кеша одну модель.
    func evict(named name: String) {
        _ = lock.withLock {
            cache.removeValue(forKey: name)
        }
    }

}
