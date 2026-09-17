//
//  DataSource.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

struct DataSource {
    
    static let idle = SceneModel(name: "idle", radiusOrbitMul: 2.0, azimuth: .pi / 8, elevation: .pi / 6, scaledCenterMulX: 0, scaledCenterMulY: 0.1, scaledCenterMulZ: 0)
    
    let exercises: [ExerciseRawModel] = [
        ExerciseRawModel(name: "Классические отжимания от пола - 1", description: "Что тренирует: большая грудная мышца, трицепсы, передние дельтовидные мышцы, мышцы кора (в качестве стабилизаторов). Упражнение развивает силу верхней части тела.\n\tТехника выполнения:\n\t1.  Примите упор лёжа: ладони на ширине плеч (или чуть шире), пальцы направлены вперёд, ноги вместе или слегка расставлены.\n\t2. Тело — прямая линия от макушки до пяток. Пресс и ягодицы напряжены, таз не провисает и не поднимается.\n\t3. На вдохе согните руки в локтях и опуститесь грудью почти до пола. Локти направлены назад под углом ~45° к корпусу, а не строго в стороны.\n\t4. На выдохе мощным усилием выжмите себя вверх, полностью выпрямляя руки, но не блокируя локти жёстко.\n\t5. Держите шею нейтрально, взгляд в пол перед собой.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_pushup", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pushup", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "pushup_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        ExerciseRawModel(name: "Планка (классическая на предплечьях) - 2", description: "Что тренирует: мышцы кора (прямая и поперечная мышцы живота, косые мышцы), мышцы спины, плечи, ягодицы, ноги. Упражнение развивает статическую выносливость и стабильность корпуса.\n\tТехника выполнения:\n\t1. Лягте на живот, затем поднимитесь на предплечья и носки стоп. \n\t2. Локти расположены строго под плечевыми суставами, предплечья параллельны друг другу (или слегка сведены).\n\t3. Тело образует прямую линию от макушки до пяток. Не допускайте провисания таза или поднятия ягодиц вверх.\n\t4. Напрягите пресс, ягодицы и бёдра. Шея — продолжение позвоночника, взгляд направлен в пол перед собой.\n\t5. Дыхание ровное, без задержек. Держите положение заданное время",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        ExerciseRawModel(name: "Прыжки с разведением рук и ног - 3", description: "Техника выполнения:\n\t1. Исходное положение: стоя прямо, ноги вместе, руки опущены вдоль тела.\n\t2. Сделайте прыжок, одновременно разводя ноги на ширину плеч (или чуть шире) и поднимая руки через стороны вверх — над головой. Можно сделать хлопок ладонями.\n\t3. Вторым прыжком вернитесь в исходное положение: ноги вместе, руки вниз.\n\t4. Держите корпус прямым, пресс слегка напряжён, взгляд направлен вперёд.\n\t5. Приземляйтесь мягко на подушечки стоп, слегка сгибая колени. Дыхание ровное, без задержек.\n\t6. Выполняйте в удобном темпе определённое время.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_jumping_jacks", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "jumping_jacks", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "jumping_jacks_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        ExerciseRawModel(name: "Берпи - 4", description: "Что тренирует: всё тело — грудные, трицепсы, плечи, мышцы кора, ноги и ягодицы. Также мощно нагружает сердечно-сосудистую систему, развивает выносливость, координацию и взрывную силу.\n\tТехника выполнения:\n\t1. Исходное положение — стоя прямо, ноги на ширине плеч, руки вдоль тела.\n\t2. Присядьте и поставьте ладони на пол перед собой.\n\t3. Прыжком (или шагом) отправьте ноги назад в упор лёжа — планка. Тело должно быть прямым.\n\t4. Выполните одно отжимание (классическое или с колен — по уровню подготовки).\n\t5. Прыжком (или шагом) верните ноги к рукам, оказываясь в приседе.\n\t6. Из приседа выпрыгните вверх, вытянув руки над головой. Можно сделать хлопок.\n\t7. Мягко приземлитесь на подушечки стоп, слегка сгибая колени, и сразу переходите к следующему повторению.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_burpee", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "burpee", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "burpee_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        ExerciseRawModel(name: "Ситапы / Подъёмы туловища из положения лёжа - 5", description: "Что тренирует: прямую мышцу живота, косые мышцы, мышцы-сгибатели бедра (подвздошно-поясничную), а также мышцы кора. Упражнение развивает силу пресса и выносливость.\n Техника выполнения:\n\t1. Лягте на спину, колени согнуты под углом ~90°, стопы полностью стоят на полу на ширине бёдер.\n\t2. Руки можно скрестить на груди или положить за голову (пальцы не сцеплены, локти разведены).\n\t3. Напрягите пресс и плавно оторвите лопатки от пола, затем поднимите корпус до касания бёдер или коленей. Поясница не должна сильно прогибаться.\n\t4. На выдохе — подъём, на вдохе — плавное опускание. Не падайте вниз, контролируйте движение.\n\t5. В нижней точке не расслабляйте пресс полностью, чтобы сохранять напряжение.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "situps_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        ExerciseRawModel(name: "Велосипед / Скручивания «велосипед» - 6", description: "Что тренирует: прямую и косые мышцы живота, мышцы кора, сгибатели бедра. Хорошо прорабатывает боковой пресс и развивает координацию.\n\tТехника выполнения:\n\t1. Лягте на спину, поясница прижата к полу. Руки за головой, пальцы не сцеплены, локти разведены. Ноги подняты, колени согнуты под углом ~90°.\n\t2. На выдохе оторвите лопатки от пола и потянитесь правым локтем к левому колену, одновременно выпрямляя правую ногу вперёд (не касаясь пола).\n\t3. На вдохе вернитесь в центр, затем повторите в другую сторону: левый локоть к правому колену, левая нога выпрямляется.\n\t4. Движение плавное и контролируемое, как будто крутите педали. Шея расслаблена, подбородок не прижат к груди.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_bicycle_situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "bicycle_crunch", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "bicycle_situps_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        ExerciseRawModel(name: "Приседания «пистолетик» - 7", description: "Что тренирует: квадрицепсы, ягодицы, заднюю поверхность бедра, мышцы кора, а также баланс, координацию и подвижность голеностопа и тазобедренного сустава. Это одно из самых сложных упражнений на одной ноге.\n\tТехника выполнения:\n\t1. Встаньте прямо, стопы на ширине плеч. Перенесите вес на одну ногу, вторую вытяните вперёд, слегка оторвав от пола. Руки вытяните перед собой для баланса.\n\t2. Медленно приседайте на опорной ноге, отводя таз назад, как при обычном приседе. Пятка опорной ноги остаётся на полу, колено движется по направлению носка, не заваливается внутрь.\n\t3. Опускайтесь максимально низко, насколько позволяет гибкость и контроль. Спина прямая, грудь раскрыта, взгляд направлен вперёд.\n\t4. На выдохе мощным усилием выжмите себя вверх, полностью выпрямляя опорную ногу. Вытянутая нога остаётся на весу.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_pistol", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pistol", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "pistol_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        ExerciseRawModel(name: "Ходьба в позе «пика» - 8", description: "Что тренирует: плечи, мышцы кора, заднюю поверхность бедра, икры, а также подвижность плечевого пояса, голеностопов и растяжку задней цепи. Упражнение сочетает силовую работу с динамической мобильностью.\nТехника выполнения:\n\t1. Исходное положение — упор лёжа (планка): ладони под плечами, тело прямо, пресс и ягодицы напряжены.\n\t2. Небольшими шагами подтягивайте стопы к ладоням, одновременно поднимая таз вверх. Тело образует угол — поза «пика» (как в «собаке мордой вниз»). Ноги старайтесь держать прямыми, но если не хватает гибкости, можно слегка согнуть колени.\n\t3. В верхней точке пятки тянутся к полу, голова находится между руками, шея расслаблена.\n\t4. Затем шагами рук вперёд вернитесь в упор лёжа. Это одно повторение.\n\t5. Движения плавные, без рывков. Дыхание ровное: при подтягивании ног — выдох, при возврате в планку — вдох.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pike_walk", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0))),
        
    ]
}
