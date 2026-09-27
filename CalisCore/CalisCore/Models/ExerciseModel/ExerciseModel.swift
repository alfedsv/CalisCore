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
    let exerciseScenes: ExerciseScenesModel
    var currentState: CurrentState = .begin
    var currentPhase: CurrentPhase = .idle
    let setDuration: Int        // длительность одного подхода (сек)
    let recoveryDuration: Int   // отдых после подхода (сек)
    let setsCount: Int          // количество подходов
    let exerciseDuration: Int   // время выполнения всего уражнения
    var progress: Int = 0
    let isLastExercise: Bool
    let steps: [ExerciseStep]

    init(id: UUID, index: Int, title: String, description: String, exerciseScenes: ExerciseScenesModel, setDuration: Int, recoveryDuration: Int, setsCount: Int, restBetweenCycles: Int, isLastExercise: Bool) {
        self.id = id
        self.index = index
        self.title = title
        self.description = description
        self.exerciseScenes = exerciseScenes
        self.setDuration = setDuration
        self.recoveryDuration = recoveryDuration
        self.setsCount = setsCount
        var steps: [ExerciseStep] = []
        self.isLastExercise = isLastExercise
        for setIndex in 0..<setsCount {
            steps.append(ExerciseStep(kind: .setDuration, duration: setDuration))
            let isLastSet = (setIndex == setsCount - 1)
            // Не добавляем отдых после самого последнего подхода, самого последнего упражнения
            if !(isLastSet && isLastExercise) {
                steps.append(ExerciseStep(kind: .restDuration, duration: recoveryDuration))
            }
        }
        // Не добавляем межцикловый отдых после самого последнего подхода, самого последнего упражнения
        if restBetweenCycles > 0 && !isLastExercise {
            steps.append(ExerciseStep(kind: .circuitRestDuration, duration: restBetweenCycles))
        }
        self.steps = steps
        self.exerciseDuration = steps.reduce(0) { $0 + $1.duration }
    }
}
