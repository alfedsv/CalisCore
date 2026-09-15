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

    var exerciseModels: [ExerciseModel] = []

    init(workoutDuration: Int, exercisesCount: Int) {
        self.workoutDuration = workoutDuration
        self.exercisesCount = exercisesCount
        let workoutHelper = WorkoutHelper(totalDuration: workoutDuration, userExercisesCount: exercisesCount)
        exerciseModels = workoutHelper.getWorkoutExercises()
    }
}
