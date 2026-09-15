//
//  ExerciseModel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation


final class ExerciseModel {

    let id: UUID
    let index: Int
    let title: String
    let description: String
    let positions: Workout.Positions
    var currentState: CurrentState = .begin
    let setDuration: Int        // длительность одного подхода (сек)
    let recoveryDuration: Int   // отдых после подхода (сек)
    let setsCount: Int          // количество подходов
    let exerciseDuration: Int   // время выполнения всего уражнения
    var progress: Int = 0

    init(id: UUID, index: Int, title: String, description: String, positions: Workout.Positions, setDuration: Int, recoveryDuration: Int, setsCount: Int) {
        self.id = id
        self.index = index
        self.title = title
        self.description = description
        self.positions = positions
        self.setDuration = setDuration
        self.recoveryDuration = recoveryDuration
        self.setsCount = setsCount
        self.exerciseDuration = (setDuration + recoveryDuration) * setsCount
    }

}
