//
//  Character.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 17.10.2026.
//

import Foundation

import Foundation

/// Персонаж для карусели выбора.
///
/// Для POC используются существующие сцены из `DataSource`. 
struct Character: Identifiable, Equatable {
    let id: String
    let name: String
    let idleScene: SceneModel
    let danceScene: SceneModel

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}
