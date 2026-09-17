//
//  ExerciseSceneCache.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 17.09.2026.
//

import Foundation
import SceneKit

final class ExerciseSceneCache {

    static let shared = ExerciseSceneCache()

    private var cache: [String: SCNScene] = [:]
    private let lock = NSLock()
    private var isLoading = false
    private var pendingCompletions: [() -> Void] = []

    private init() {}

    /// Предзагружает сцены по именам. Если загрузка уже идёт —
    /// колбэк будет вызван после её завершения.
    func preload(names: Set<String>, completion: (() -> Void)? = nil) {
        lock.lock()

        // Уже есть всё необходимое — завершаем сразу
        let missing = names.filter { cache[$0] == nil }
        if missing.isEmpty {
            lock.unlock()
            DispatchQueue.main.async { completion?() }
            return
        }

        if let completion = completion {
            pendingCompletions.append(completion)
        }

        // Загрузка уже идёт — просто ждём
        if isLoading {
            lock.unlock()
            return
        }

        isLoading = true
        lock.unlock()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var loaded: [String: SCNScene] = [:]
            for name in missing {
                guard let url = Bundle.main.url(forResource: name, withExtension: "dae"),
                      let scene = SCNSceneSource(url: url, options: nil)?.scene(options: nil)
                else {
                    print("Не удалось предзагрузить сцену \(name)")
                    continue
                }
                loaded[name] = scene
            }

            self.lock.lock()
            for (key, value) in loaded {
                self.cache[key] = value
            }
            self.isLoading = false
            let callbacks = self.pendingCompletions
            self.pendingCompletions.removeAll()
            self.lock.unlock()

            DispatchQueue.main.async {
                callbacks.forEach { $0() }
            }
        }
    }

    /// Достаёт сцену из кеша (без загрузки).
    func scene(named name: String) -> SCNScene? {
        lock.lock()
        defer { lock.unlock() }
        return cache[name]
    }
}
