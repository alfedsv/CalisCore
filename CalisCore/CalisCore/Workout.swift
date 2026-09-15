//
//  Workout.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

struct Workout {
    
    struct Positions {
        let idle: Scene
        let idleToWorkoutScene: Scene
        let workoutScene: Scene
        let workoutToIdleScene: Scene
    }
    
    struct Scene {
        let name: String
        let radiusOrbitMul: Float
        let azimuth: Float
        let elevation: Float
        let scaledCenterMulX: Float
        let scaledCenterMulY: Float
        let scaledCenterMulZ: Float
    }
    
    struct Exercise: Identifiable {
        let id: UUID
        let name: String
        let description: String
        let positions: Positions
        init(name: String, description: String, positions: Positions) {
            self.id = UUID()
            self.name = name
            self.description = description
            self.positions = positions
        }
    }
    
    func getExercises() -> [Exercise] {
        return exercises
    }

    let exercises: [Exercise] = [
        Exercise(name: "Классические отжимания 1", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 2", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 3", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 4", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 5", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 6", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 7", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 8", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 9", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 10", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 11", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 12", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 13", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 14", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 15", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 16", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        Exercise(name: "Классические отжимания 17", description: "Исходное положение — упор лёжа. Опустите грудь к полу, затем выжмите себя вверх, сохраняя тело прямым.",
                 positions: Positions(
                    idle: Scene(name: "idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    idleToWorkoutScene: Scene(name: "idle_to_pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: Scene(name: "pushup", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: Scene(name: "pushup_to_idle", radiusOrbitMul: 3.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0)))
    ]
}
