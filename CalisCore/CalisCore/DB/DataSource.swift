//
//  DataSource.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

struct DataSource {
    
    static let idle = SceneModel(name: "idle", radiusOrbitMul: 2.0, azimuth: .pi / 8, elevation: .pi / 6, scaledCenterMulX: 0, scaledCenterMulY: 0.1, scaledCenterMulZ: 0)
    static let victory = SceneModel(name: "victory", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 7, scaledCenterMulX: 0, scaledCenterMulY: 0.3, scaledCenterMulZ: 0)
    
    static func getName(named: String) -> String {
        return ("workout.name." + named).localized
    }
    
    static func getDescription(named: String) -> String {
        return ("workout.description." + named).localized + "\n\n" + ("workout.technique." + named).localized + "\n\n" + ("workout.warning." + named).localized + "\n\n" + ("workout.advise." + named).localized
    }

    static let exercises: [ExerciseRawModel] = [
        ExerciseRawModel(name: getName(named: "pushup"), description: getDescription(named: "pushup"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_pushup", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pushup", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "pushup_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "plank"), description: getDescription(named: "plank"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "jumping_jacks"), description: getDescription(named: "jumping_jacks"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_jumping_jacks", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "jumping_jacks", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "jumping_jacks_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "burpee"), description: getDescription(named: "burpee"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_burpee", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "burpee", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "burpee_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "situps"), description: getDescription(named: "situps"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "situps_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "bicycle_situp"), description: getDescription(named: "bicycle_situp"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_bicycle_situp", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "bicycle_crunch", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "bicycle_situp_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "pistol"), description: getDescription(named: "pistol"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_pistol", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pistol", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "pistol_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "pike"), description: getDescription(named: "pike"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pike_walk", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "jump_pushup"), description: getDescription(named: "jump_pushup"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "jump_pushup", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "cross_jumps_rotation"), description: getDescription(named: "cross_jumps_rotation"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: nil,
                    workoutScene: SceneModel(name: "cross_jumps_rotation", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: nil,
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: getName(named: "cross_jumps"), description: getDescription(named: "cross_jumps"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: nil,
                    workoutScene: SceneModel(name: "cross_jumps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: nil,
                    isWorkoutReversed: true)),
        ExerciseRawModel(name: getName(named: "circle_crunch"), description: getDescription(named: "circle_crunch"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "circle_crunch", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "situps_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: true)),
        ExerciseRawModel(name: getName(named: "squat"), description: getDescription(named: "squat"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: nil,
                    workoutScene: SceneModel(name: "squat", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: nil,
                    isWorkoutReversed: true)),
        ExerciseRawModel(name: getName(named: "squat_bent_arms"), description: getDescription(named: "squat_bent_arms"),
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: nil,
                    workoutScene: SceneModel(name: "squat_bent_arms", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: nil,
                    isWorkoutReversed: true)),
    ]
}
