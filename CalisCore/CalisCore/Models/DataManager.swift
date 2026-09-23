//
//  DataManager.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

final class DataManager {
    
    struct ExercisePlanModel {
        let setDuration: Int            // длительность одного подхода (сек)
        let recoveryDuration: Int       // отдых после подхода (сек)
        let setsCount: Int              // количество подходов
        let restBetweenCycles: Int
    }
    
    private let totalDuration: Int          // общая длительность тренировки (сек)
    private let userExercisesCount: Int     // количество упражнений, выбранное пользователем
    private let workoutType: WorkoutType    // тип тренировки

    private var restBetweenCycles: Int {
        return workoutType == .circuit ? 60 : 0
    }
    
    private let cyclesCount: Int
    
    private var totalExercisesCount: Int {
        return userExercisesCount * cyclesCount
    }
    
    private var timePerExercise: Int {
        let available = totalDuration - ((cyclesCount - 1) * restBetweenCycles)
        return available / totalExercisesCount   // целочисленное деление (округление вниз)
    }
    
    private var exercisePlans: [ExercisePlanModel] {
        var plan: [ExercisePlanModel] = []
        for cycle in 0..<cyclesCount {
            for exerciseIndex in 0..<userExercisesCount {
                let setDuration = randomSetDuration(workoutType: workoutType)   // длительность подхода
                let recoveryDuration = recoveryDuration(workoutType: workoutType, setDuration: setDuration)
                let cycleTime = setDuration + recoveryDuration
                let setsCount = max(1, (timePerExercise - (restBetweenCycles)) / cycleTime)
                let isLast = (exerciseIndex == userExercisesCount - 1)
                let isVeryLast = (cycle == cyclesCount - 1) && isLast
                let rest = (isLast && !isVeryLast && workoutType == .circuit) ? restBetweenCycles : 0
                plan.append(ExercisePlanModel(
                    setDuration: setDuration,
                    recoveryDuration: recoveryDuration,
                    setsCount: setsCount,
                    restBetweenCycles: rest
                ))
            }
        }
        return plan
    }
    
    init(totalDuration: Int, userExercisesCount: Int, workoutType: WorkoutType) {
        self.totalDuration = totalDuration
        self.userExercisesCount = userExercisesCount
        self.workoutType = workoutType
        if workoutType == .circuit {
            self.cyclesCount = Int.randomTriangular(min: 1, max: 7, mode: 4)
        } else {
            self.cyclesCount = 1
        }
    }
    
    func getWorkoutExercises() -> [ExerciseModel] {
        let exs: [ExerciseRawModel] = DataSource.exercises
        guard exs.count >= userExercisesCount else {
            #if DEBUG
            print("[ERROR] Недостаточно упражнений в базе: нужно \(userExercisesCount), есть \(exs.count)")
            #endif
            return []
        }
        
        let pickedExercises = Array(exs.shuffled().prefix(userExercisesCount))
        let plans = exercisePlans
        let expectedCount = pickedExercises.count * cyclesCount
        guard plans.count == expectedCount else {
            #if DEBUG
            print("[ERROR] plans.count (\(plans.count)) != expected (\(expectedCount))")
            #endif
            return []
        }
        var models: [ExerciseModel] = []
        models.reserveCapacity(plans.count)
        for (index, plan) in plans.enumerated() {
            let exercise = pickedExercises[index % pickedExercises.count]
            let model = ExerciseModel(
                id: exercise.id,
                index: index,
                title: exercise.name,
                description: exercise.description,
                exerciseScenes: exercise.exerciseScenes,
                setDuration: plan.setDuration,
                recoveryDuration: plan.recoveryDuration,
                setsCount: plan.setsCount,
                restBetweenCycles: plan.restBetweenCycles
            )
            models.append(model)
        }
        return models
    }
    
    // Генерация длительности подхода (кратно 5)
    private func randomSetDuration(workoutType: WorkoutType) -> Int {
        let range: ClosedRange<Int>
        switch workoutType {
        case .strength: range = 45...90
        case .endurance: range = 60...120
        case .explosivePower: range = 15...30
        case .circuit: range = 40...60
        }
        let raw = Int.random(in: range)
        return (raw / 5) * 5   // округление вниз до кратного 5
    }
    
    // Время восстановления после подхода
    private func recoveryDuration(workoutType: WorkoutType, setDuration: Int) -> Int {
        switch workoutType {
        case .strength: return setDuration
        case .endurance: return setDuration / 2
        case .explosivePower: return setDuration * 2
        case .circuit: return setDuration / 3
        }
    }
}
