//
//  SetupViewModel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

protocol SetupViewModelProtocol: AnyObject {

    var workoutDurationMinutes: Int { get }
    var exercisesCount: Int { get }
    var onUpdate: (() -> Void)? { get set }
    var onNext: ((WorkoutModel) -> Void)? { get set }
    func workoutDurationUpdate(minutes: Int)
    func exercisesCountUpdate(count: Int)
    func next()
}

final class SetupViewModel: SetupViewModelProtocol {
    
    private(set) var workoutDurationMinutes: Int
    private(set) var exercisesCount: Int

    var onUpdate: (() -> Void)?
    var onNext: ((WorkoutModel) -> Void)?
    
    init() {
        self.workoutDurationMinutes = WorkoutModelConstants.workoutDurationDefault
        self.exercisesCount = WorkoutModelConstants.exercisesCountDefault
    }
    
    func workoutDurationUpdate(minutes: Int) {
        self.workoutDurationMinutes = minutes
        self.onUpdate?()
    }

    func exercisesCountUpdate(count: Int) {
        self.exercisesCount = count
        self.onUpdate?()
    }

    func next() {
        if exercisesCount > 0 {
            let workoutModel = WorkoutModel(
                workoutDuration: workoutDurationMinutes * 60,
                exercisesCount: exercisesCount
            )
            onNext?(workoutModel)
        }
    }
}
