//
//  Entity+LoadFromBundle.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 16.10.2026.
//

import Foundation
import RealityKit

extension Entity {

    /// Загружает Entity из бандла асинхронно без Combine.
    ///
    /// - **iOS 18+**: нативный async-инициализатор `Entity(named:in:)`.
    /// - **iOS 13–17**: синхронный `Entity.load(named:in:)` выполняется
    ///   в фоновой очереди; результат и ошибка прокидываются через
    ///   `withCheckedThrowingContinuation` с явно указанным типом.
    ///
    /// - Parameters:
    ///   - name: имя USDZ-ресурса без расширения (например, `"pushup"`).
    ///   - bundle: бандл с ресурсом. По умолчанию — main.
    /// - Returns: загруженная сущность-шаблон.
    /// - Throws: ошибку RealityKit, если ресурс не найден или повреждён.
    static func loadFromBundle(named name: String,
                               in bundle: Bundle = .main) async throws -> Entity {
        if #available(iOS 18.0, *) {
            return try await Entity(named: name, in: bundle)
        }

        // Явная типизация continuation обязательна: без неё Swift может
        // вывести `withCheckedContinuation` (Failure == Never) и выдать
        // ошибку "Thrown expression type 'any Error' cannot be converted
        // to error type 'Never'".
        return try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Entity, Error>) in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let entity = try Entity.load(named: name, in: bundle)
                    continuation.resume(returning: entity)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
