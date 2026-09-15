//
//  WorkoutViewModel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

protocol WorkoutViewModelProtocol: AnyObject {
    
    var exerciseNumber: Int { get }
    var exercisesCount: Int { get }
    var exerciseModel: ExerciseModel { get }
    var onUpdate: (() -> Void)? { get set }
    var onStarted: (() -> Void)? { get set }
    var onStoped: (() -> Void)? { get set }
    var onEnded: (() -> Void)? { get set }
    var onNext: ((WorkoutModel) -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
    func control()
    func next()
    func back()
}

final class WorkoutViewModel: WorkoutViewModelProtocol {

    var exerciseNumber: Int
    var exercisesCount: Int
    var exerciseModel: ExerciseModel
    var onUpdate: (() -> Void)?
    var onStarted: (() -> Void)?
    var onStoped: (() -> Void)?
    var onEnded: (() -> Void)?
    var onNext: ((WorkoutModel) -> Void)?
    var onFinish: (() -> Void)?
    private var exerciseIndex: Int {
        return workoutModel.currentExerciseIndex
    }
    private let workoutModel: WorkoutModel
    private var timer: Timer?
    
    init(workoutModel: WorkoutModel) {
        self.workoutModel = workoutModel
        self.exerciseModel = workoutModel.exerciseModels[workoutModel.currentExerciseIndex]
        self.exerciseNumber = workoutModel.currentExerciseIndex + 1
        self.exercisesCount = workoutModel.exerciseModels.count
    }
    
    deinit {
        switch exerciseModel.currentState {
        case .running:
            exerciseModel.currentState = .stopped
            stopTimer()
            onStoped?()
        case .begin, .ended, .stopped:
            break
        }
        stopTimer()
    }
    
    private func startTimer() {
        self.onUpdate?()
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.exerciseModel.progress >= self.exerciseModel.exerciseDuration {
                self.stopTimer()
                self.exerciseModel.currentState = .ended
                self.exerciseModel.progress = self.exerciseModel.exerciseDuration
                self.onUpdate?()
                return
            }
            self.exerciseModel.progress = Int(Double(self.exerciseModel.progress) + 1.0)
            self.onUpdate?()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func control() {
        switch exerciseModel.currentState {
        case .running:
            exerciseModel.currentState = .stopped
            stopTimer()
            onStoped?()
        case .begin, .stopped:
            exerciseModel.currentState = .running
            startTimer()
            onStarted?()
        case .ended:
            break
        }
    }

    func next() {
        navigation()
        if exerciseIndex < exercisesCount - 1 {
            workoutModel.currentExerciseIndex = exerciseIndex + 1
            onNext?(workoutModel)
        } else if exerciseIndex == exercisesCount - 1 {
            onFinish?()
        }
    }
    
    func back() {
        navigation()
        if exerciseIndex > 0 {
            workoutModel.currentExerciseIndex = exerciseIndex - 1
        }
    }
    
    
    private func navigation() {
        if exerciseModel.currentState == .running {
            exerciseModel.currentState = .stopped
            stopTimer()
            onStoped?()
        }
    }
}
