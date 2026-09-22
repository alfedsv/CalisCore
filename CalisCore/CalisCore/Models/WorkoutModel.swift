//
//  WorkoutModel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

final class WorkoutModel {
    
    var workoutDuration: Int
    var exercisesCount: Int
    var currentExerciseIndex: Int = 0
    let workoutType: WorkoutType

    var exerciseModels: [ExerciseModel] = []

    init(workoutDuration: Int, exercisesCount: Int, workoutType: WorkoutType) {
        self.workoutDuration = workoutDuration
        self.exercisesCount = exercisesCount
        self.workoutType = workoutType
        let workoutHelper = WorkoutHelper(totalDuration: workoutDuration, userExercisesCount: exercisesCount, workoutType: workoutType)
        exerciseModels = workoutHelper.getWorkoutExercises()
    }
}
