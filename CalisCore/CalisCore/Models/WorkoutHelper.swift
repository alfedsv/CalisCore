//
//  WorkoutHelper.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

final class WorkoutHelper {
    
    struct ExercisePlanModel {
        let setDuration: Int            // длительность одного подхода (сек)
        let recoveryDuration: Int       // отдых после подхода (сек)
        let setsCount: Int              // количество подходов
        let isLastInCycle: Bool         // если последнее упраженеие в круге
    }

    private let totalDuration: Int          // общая длительность тренировки (сек)
    private let userExercisesCount: Int     // количество упражнений, выбранное пользователем
    
    private var mainWorkoutTime: Int {
        return totalDuration
    }
    
    private let restBetweenSets: Int = 60
    private var restBetweenCycles: Int = 0
    private let cyclesCount: Int = 1
    
    private var totalExercisesCount: Int {
        return userExercisesCount * cyclesCount
    }
    
    private var timePerExercise: Int {
        // (mainWorkoutTime - отдых между кругами) / общее количество упражнений
        let available = mainWorkoutTime - ((cyclesCount - 1) * restBetweenCycles)
        return available / totalExercisesCount   // целочисленное деление (округление вниз)
    }
    
    private var exercisePlans: [ExercisePlanModel] {
        var plan: [ExercisePlanModel] = []
        print("Количество упраженений:\t\(totalExercisesCount)")
        print("Количество кругов:\t\(cyclesCount)")
        print("Время на всю тренировку:\t\(totalDuration)")
        for cycle in 0..<cyclesCount {
            print("Круг (index):\t\(cycle)")
            for exerciseIndex in 0..<userExercisesCount {
                print("Упражнение (index):\t\(exerciseIndex)")
                let setDuration = randomSetDuration()   // длительность подхода
                let recoveryDuration = recoveryDuration(setDuration: setDuration)
                let setsCount = timePerExercise / (setDuration + recoveryDuration)
                let isLast = (exerciseIndex % userExercisesCount == userExercisesCount - 1)
                print("\tКоличество походов:\t\(setsCount)")
                print("\tВремя на все упраженение:\t\(timePerExercise)")
                print("\tВремя на один подход:\t\(setDuration)")
                print("\tВремя на одых после подхода:\t\(recoveryDuration)")
                plan.append(ExercisePlanModel(setDuration: setDuration, recoveryDuration: recoveryDuration, setsCount: setsCount, isLastInCycle: isLast))
            }
        }
        return plan
    }

    init(totalDuration: Int, userExercisesCount: Int) {
        self.totalDuration = totalDuration
        self.userExercisesCount = userExercisesCount
    }

    func getWorkoutExercises() -> [ExerciseModel] {
        let dataSource: Workout = Workout()
        let exs: [Workout.Exercise] = dataSource.getExercises()
        guard exs.count >= userExercisesCount else {
            print("[ERROR] Недостаточно упражнений в базе для выбранного количества")
            return []
        }
        let baseExercises = exs.shuffled().prefix(userExercisesCount).map { $0 }
        let exercises = Array(repeating: baseExercises, count: cyclesCount).flatMap { $0 }
        guard exercises.count == exercisePlans.count else {
            print("[ERROR] exercises.count (\(exercises.count)) != exercisePlans.count (\(exercisePlans.count))")
            return []
        }
        var models: [ExerciseModel] = []
        for (index, exercisePlanModel) in exercisePlans.enumerated() {
            let model = ExerciseModel(
                id: exercises[index].id,
                index: index,
                title: exercises[index].name,
                description: exercises[index].description,
                positions: exercises[index].positions,
                setDuration: exercisePlanModel.setDuration,
                recoveryDuration: exercisePlanModel.recoveryDuration,
                setsCount: exercisePlanModel.setsCount
            )
            models.append(model)
        }
        return models
    }
    
    func getWorkoutExercisesCount() -> Int {
        let dataSource: Workout = Workout()
        let exs: [Workout.Exercise] = dataSource.getExercises()
        return exs.count
    }

    // Генерация длительности подхода (кратно 5)
    private func randomSetDuration() -> Int {
        let range: ClosedRange<Int> = 45...90
        let raw = Int.random(in: range)
        return (raw / 5) * 5   // округление вниз до кратного 5
    }
    
    // Время восстановления после подхода
    private func recoveryDuration(setDuration: Int) -> Int {
        return setDuration
    }
    
}
