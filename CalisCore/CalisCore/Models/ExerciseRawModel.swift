//
//  ExerciseRawModel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 16.09.2026.
//

import Foundation

struct ExerciseRawModel: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let exerciseScenes: ExerciseScenesModel
    init(name: String, description: String, positions: ExerciseScenesModel) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.exerciseScenes = positions
    }
}
