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
    var onStopped: (() -> Void)? { get set }
    var onEnded: (() -> Void)? { get set }
    var onPhaseChanged: ((CurrentPhase) -> Void)? { get set }
    var onToDescription: ((String, String) -> Void)? { get set }
    var onNext: ((WorkoutModel) -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }

    func setExerciseModelPhase(phase: CurrentPhase)
    func control()
    func next()
    func toDescription()
    func back()
}

final class WorkoutViewModel: WorkoutViewModelProtocol {

    // MARK: - Public

    var exerciseNumber: Int
    var exercisesCount: Int
    var exerciseModel: ExerciseModel

    // MARK: - Callbacks

    var onUpdate: (() -> Void)?
    var onStarted: (() -> Void)?
    var onStopped: (() -> Void)?
    var onEnded: (() -> Void)?
    var onPhaseChanged: ((CurrentPhase) -> Void)?
    var onToDescription: ((String, String) -> Void)?
    var onNext: ((WorkoutModel) -> Void)?
    var onFinish: (() -> Void)?
    
    // MARK: - Private
    
    private var exerciseIndex: Int {
        return workoutModel.currentExerciseIndex
    }
    private let workoutModel: WorkoutModel
    private var timer: Timer?
    private var lastNotifiedPhase: CurrentPhase = .idle
    private var currentStepIndex: Int? {
        var acc = 0
        for (i, step) in exerciseModel.steps.enumerated() {
            if exerciseModel.progress < acc + step.duration { return i }
            acc += step.duration
        }
        return nil
    }
    private var currentStep: ExerciseStep? {
        guard let i = currentStepIndex else { return nil }
        return exerciseModel.steps[i]
    }

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
            onStopped?()
        case .begin, .ended, .stopped:
            break
        }
        stopTimer()
    }

    // MARK: - Timer
    
    private func startTimer() {
        self.onUpdate?()
        self.updatePhase()
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.exerciseModel.progress >= self.exerciseModel.exerciseDuration {
                self.stopTimer()
                self.exerciseModel.currentState = .ended
                self.exerciseModel.progress = self.exerciseModel.exerciseDuration
                self.onUpdate?()
                self.updatePhase()
                self.onEnded?()
                return
            }
            self.exerciseModel.progress = Int(Double(self.exerciseModel.progress) + 1.0)
            self.onUpdate?()
            self.updatePhase() 
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Phase
    
    private func updatePhase() {
        let target: CurrentPhase = {
            guard exerciseModel.currentState == .running, let step = currentStep else { return .idle }
            return step.kind == .setDuration ? .workout : .idle
        }()
        guard target != lastNotifiedPhase else { return }
        lastNotifiedPhase = target
        onPhaseChanged?(target)
    }
    
    func setExerciseModelPhase(phase: CurrentPhase) {
        exerciseModel.currentPhase = phase
    }
    
    func control() {
        switch exerciseModel.currentState {
        case .running:
            exerciseModel.currentState = .stopped
            stopTimer()
            updatePhase()
            onStopped?()
        case .begin, .stopped:
            exerciseModel.currentState = .running
            startTimer()
            onStarted?()
        case .ended:
            break
        }
    }

    // MARK: - Navigation

    func next() {
        navigation()
        if exerciseIndex < exercisesCount - 1 {
            workoutModel.currentExerciseIndex = exerciseIndex + 1
            onNext?(workoutModel)
        } else if exerciseIndex == exercisesCount - 1 {
            onFinish?()
        }
    }
    
    func toDescription() {
        onToDescription?(exerciseModel.title, exerciseModel.description)
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
            updatePhase()
            onStopped?()
        }
    }
}

