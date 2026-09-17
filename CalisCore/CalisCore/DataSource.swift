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
    
    static let exercises: [ExerciseRawModel] = [
        ExerciseRawModel(name: "Классические отжимания от пола", description: "\tЧто тренирует: большая грудная мышца, трицепсы, передние дельтовидные мышцы, мышцы кора (в качестве стабилизаторов). Упражнение развивает силу верхней части тела.\n\tТехника выполнения:\n\t1.  Примите упор лёжа: ладони на ширине плеч (или чуть шире), пальцы направлены вперёд, ноги вместе или слегка расставлены.\n\t2. Тело — прямая линия от макушки до пяток. Пресс и ягодицы напряжены, таз не провисает и не поднимается.\n\t3. На вдохе согните руки в локтях и опуститесь грудью почти до пола. Локти направлены назад под углом ~45° к корпусу, а не строго в стороны.\n\t4. На выдохе мощным усилием выжмите себя вверх, полностью выпрямляя руки, но не блокируя локти жёстко.\n\t5. Держите шею нейтрально, взгляд в пол перед собой.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_pushup", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pushup", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "pushup_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Планка (классическая на предплечьях)", description: "\tЧто тренирует: мышцы кора (прямая и поперечная мышцы живота, косые мышцы), мышцы спины, плечи, ягодицы, ноги. Упражнение развивает статическую выносливость и стабильность корпуса.\n\tТехника выполнения:\n\t1. Лягте на живот, затем поднимитесь на предплечья и носки стоп. \n\t2. Локти расположены строго под плечевыми суставами, предплечья параллельны друг другу (или слегка сведены).\n\t3. Тело образует прямую линию от макушки до пяток. Не допускайте провисания таза или поднятия ягодиц вверх.\n\t4. Напрягите пресс, ягодицы и бёдра. Шея — продолжение позвоночника, взгляд направлен в пол перед собой.\n\t5. Дыхание ровное, без задержек. Держите положение заданное время",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Прыжки с разведением рук и ног", description: "\tТехника выполнения:\n\t1. Исходное положение: стоя прямо, ноги вместе, руки опущены вдоль тела.\n\t2. Сделайте прыжок, одновременно разводя ноги на ширину плеч (или чуть шире) и поднимая руки через стороны вверх — над головой. Можно сделать хлопок ладонями.\n\t3. Вторым прыжком вернитесь в исходное положение: ноги вместе, руки вниз.\n\t4. Держите корпус прямым, пресс слегка напряжён, взгляд направлен вперёд.\n\t5. Приземляйтесь мягко на подушечки стоп, слегка сгибая колени. Дыхание ровное, без задержек.\n\t6. Выполняйте в удобном темпе определённое время.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_jumping_jacks", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "jumping_jacks", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "jumping_jacks_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Берпи", description: "\tЧто тренирует: всё тело — грудные, трицепсы, плечи, мышцы кора, ноги и ягодицы. Также мощно нагружает сердечно-сосудистую систему, развивает выносливость, координацию и взрывную силу.\n\tТехника выполнения:\n\t1. Исходное положение — стоя прямо, ноги на ширине плеч, руки вдоль тела.\n\t2. Присядьте и поставьте ладони на пол перед собой.\n\t3. Прыжком (или шагом) отправьте ноги назад в упор лёжа — планка. Тело должно быть прямым.\n\t4. Выполните одно отжимание (классическое или с колен — по уровню подготовки).\n\t5. Прыжком (или шагом) верните ноги к рукам, оказываясь в приседе.\n\t6. Из приседа выпрыгните вверх, вытянув руки над головой. Можно сделать хлопок.\n\t7. Мягко приземлитесь на подушечки стоп, слегка сгибая колени, и сразу переходите к следующему повторению.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_burpee", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "burpee", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "burpee_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Ситапы / Подъёмы туловища из положения лёжа", description: "\tЧто тренирует: прямую мышцу живота, косые мышцы, мышцы-сгибатели бедра (подвздошно-поясничную), а также мышцы кора. Упражнение развивает силу пресса и выносливость.\n Техника выполнения:\n\t1. Лягте на спину, колени согнуты под углом ~90°, стопы полностью стоят на полу на ширине бёдер.\n\t2. Руки можно скрестить на груди или положить за голову (пальцы не сцеплены, локти разведены).\n\t3. Напрягите пресс и плавно оторвите лопатки от пола, затем поднимите корпус до касания бёдер или коленей. Поясница не должна сильно прогибаться.\n\t4. На выдохе — подъём, на вдохе — плавное опускание. Не падайте вниз, контролируйте движение.\n\t5. В нижней точке не расслабляйте пресс полностью, чтобы сохранять напряжение.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "situps_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Велосипед / Скручивания «велосипед»", description: "\tЧто тренирует: прямую и косые мышцы живота, мышцы кора, сгибатели бедра. Хорошо прорабатывает боковой пресс и развивает координацию.\n\tТехника выполнения:\n\t1. Лягте на спину, поясница прижата к полу. Руки за головой, пальцы не сцеплены, локти разведены. Ноги подняты, колени согнуты под углом ~90°.\n\t2. На выдохе оторвите лопатки от пола и потянитесь правым локтем к левому колену, одновременно выпрямляя правую ногу вперёд (не касаясь пола).\n\t3. На вдохе вернитесь в центр, затем повторите в другую сторону: левый локоть к правому колену, левая нога выпрямляется.\n\t4. Движение плавное и контролируемое, как будто крутите педали. Шея расслаблена, подбородок не прижат к груди.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_bicycle_situp", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "bicycle_crunch", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "bicycle_situp_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Приседания «пистолетик»", description: "\tЧто тренирует: квадрицепсы, ягодицы, заднюю поверхность бедра, мышцы кора, а также баланс, координацию и подвижность голеностопа и тазобедренного сустава. Это одно из самых сложных упражнений на одной ноге.\n\tТехника выполнения:\n\t1. Встаньте прямо, стопы на ширине плеч. Перенесите вес на одну ногу, вторую вытяните вперёд, слегка оторвав от пола. Руки вытяните перед собой для баланса.\n\t2. Медленно приседайте на опорной ноге, отводя таз назад, как при обычном приседе. Пятка опорной ноги остаётся на полу, колено движется по направлению носка, не заваливается внутрь.\n\t3. Опускайтесь максимально низко, насколько позволяет гибкость и контроль. Спина прямая, грудь раскрыта, взгляд направлен вперёд.\n\t4. На выдохе мощным усилием выжмите себя вверх, полностью выпрямляя опорную ногу. Вытянутая нога остаётся на весу.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_pistol", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pistol", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "pistol_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Ходьба в позе «пика»", description: "\tЧто тренирует: плечи, мышцы кора, заднюю поверхность бедра, икры, а также подвижность плечевого пояса, голеностопов и растяжку задней цепи. Упражнение сочетает силовую работу с динамической мобильностью.\nТехника выполнения:\n\t1. Исходное положение — упор лёжа (планка): ладони под плечами, тело прямо, пресс и ягодицы напряжены.\n\t2. Небольшими шагами подтягивайте стопы к ладоням, одновременно поднимая таз вверх. Тело образует угол — поза «пика» (как в «собаке мордой вниз»). Ноги старайтесь держать прямыми, но если не хватает гибкости, можно слегка согнуть колени.\n\t3. В верхней точке пятки тянутся к полу, голова находится между руками, шея расслаблена.\n\t4. Затем шагами рук вперёд вернитесь в упор лёжа. Это одно повторение.\n\t5. Движения плавные, без рывков. Дыхание ровное: при подтягивании ног — выдох, при возврате в планку — вдох.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "pike_walk", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Прыжковые отжимания / Взрывные отжимания", description: "\tЧто тренирует: грудные мышцы, трицепсы, передние дельтовидные, мышцы кора. Дополнительно развивает взрывную силу верхней части тела, мощность и координацию. Это плиометрическое упражнение, которое требует хорошей базовой подготовки.\n\tТехника выполнения:\n\t1. Примите упор лёжа: ладони на ширине плеч (или чуть шире), тело — прямая линия от макушки до пяток. Пресс и ягодицы напряжены.\n\t2. Опуститесь вниз, сгибая руки в локтях, как в классическом отжимании. Локти направлены назад под углом ~45°, грудь почти касается пола.\n\t3. Мощным взрывным усилием выжмите себя вверх так, чтобы ладони оторвались от пола. В верхней точке можно сделать хлопок ладонями или просто оторвать руки.\n\t4. Мягко приземлитесь на ладони, слегка сгибая локти для амортизации, и сразу переходите к следующему повторению (или задержитесь в планке, если нужно восстановить контроль).\n\t5. Дыхание: вдох — при опускании, резкий выдох — при взрывном выталкивании.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_plank", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "jump_push_up", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "plank_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Прыжки с перекрещиванием и поворотом", description: "\tЧто тренирует: сердечно-сосудистую систему и выносливость, мышцы кора (особенно косые), ягодицы, квадрицепсы, мышцы бедра и плеч. Это плиометрическое упражнение развивает координацию, взрывную силу и способность стабилизировать корпус во время вращения.\n\tТехника выполнения:\n\t1. Исходное положение — стоя прямо, стопы на ширине таза, руки опущены вдоль тела или согнуты перед грудью. Корпус слегка напряжён.\n\t2. Сделайте прыжок, одновременно разводя ноги чуть шире плеч и разворачивая корпус (таз и плечи) в сторону — например, вправо. Руки при этом раскрываются в стороны или одна рука тянется через корпус.\n\t3. Приземлитесь в устойчивую позицию, контролируя вращение за счёт мышц кора, а не за счёт инерции.\n\t4. Следующим прыжком вернитесь в центр или сразу переключитесь на вращение в другую сторону, перекрещивая противоположную ногу и руку (как в кросс-джеке).\n\t5. Движение должно быть ритмичным: прыжок — поворот/перекрещивание — возврат. Дыхание ровное, без задержек.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: nil,
                    workoutScene: SceneModel(name: "cross_jumps_rotation", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: nil,
                    isWorkoutReversed: false)),
        ExerciseRawModel(name: "Кросс-прыжки / Прыжки с перекрещиванием", description: "\tЧто тренирует: сердечно-сосудистую систему, выносливость и координацию. Задействует мышцы ног (икры, квадрицепсы, приводящие и отводящие мышцы бедра), ягодицы, мышцы кора и плечи.\n\tТехника выполнения:\n\t1. Исходное положение — стоя прямо, ноги на ширине таза, руки вдоль тела или согнуты перед грудью.\n\t2. Сделайте прыжок, разводя ноги в стороны и поднимая руки через стороны вверх (как в джампинг-джеке).\n\t3.  Следующим прыжком скрестите ноги (одна перед другой) и скрестите руки перед грудью.\n\t4. Чередуйте прыжки: разведение — перекрещивание. Корпус держите прямым, пресс слегка напряжён, взгляд вперёд.\n\t5. Приземляйтесь мягко на подушечки стоп, колени слегка согнуты для амортизации. Дыхание ровное, без задержек.\n\tЧастые ошибки:\n\tЖёсткое приземление на пятки — ударная нагрузка на суставы.\n\tКолени заваливаются внутрь или сильно выпрямлены.\n\tСутулость, голова уходит вперёд.\n\tСлишком быстрый темп и потеря координации.\n\tЗадержка дыхания.\n\tСлишком высокие прыжки в ущерб технике.\n\tСоветы: Новичкам можно делать облегчённый вариант без прыжка — шаг в сторону с перекрещиванием ног и рук. Уменьшите амплитуду и темп, следите за мягким приземлением. При боли в коленях, голеностопах или пояснице замените упражнение на низкоударное кардио.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: nil,
                    workoutScene: SceneModel(name: "cross_jumps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: nil,
                    isWorkoutReversed: true)),
        ExerciseRawModel(name: "Скручивания по кругу", description: "\tЧто тренирует: прямую и косые мышцы живота, мышцы кора, сгибатели бедра. Упражнение развивает силу пресса, координацию и контроль корпуса, особенно боковых мышц.\n\tТехника выполнения:\n\t1. Лягте на спину, колени согнуты, стопы на полу (или подняты — для усложнения). Руки за головой, пальцы не сцеплены, локти разведены.\n\t2. Напрягите пресс и оторвите лопатки от пола — верхняя часть корпуса в лёгком скручивании. Поясница прижата к полу.\n\t3. Начните описывать верхней частью корпуса круг: например, потянитесь правым локтем к левому колену, затем через центр к правому колену левым локтем, затем вернитесь в исходное положение. Движение плавное и непрерывное, как по кругу.\n\t4. Выполните несколько кругов в одну сторону, затем столько же в другую. Дыхание ровное: выдох на усилии, вдох при возврате.\n\t5. Амплитуда комфортная, без рывков. Шея расслаблена, подбородок не прижат к груди.\n\tЧастые ошибки:\n\tТянуть себя за шею руками — риск травмы шейного отдела.\n\tРабота по инерции и слишком быстрый темп.\n\tОтрыв поясницы от пола, прогиб в спине.\n\tСлишком большой радиус круга в ущерб контролю.\n\tЗадержка дыхания.\n\tПолное расслабление пресса в нижней точке.\n\tСоветы: Новичкам можно делать упражнение с ногами на полу и меньшей амплитудой. Если тяжело держать руки за головой — положите их на грудь или скрестите на плечах. Для усложнения поднимите ноги или выполняйте круги медленнее. При дискомфорте в шее или пояснице уменьшите амплитуду или замените на обычные скручивания.",
                 positions: ExerciseScenesModel(
                    idle: idle,
                    idleToWorkoutScene: SceneModel(name: "idle_to_situps", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutScene: SceneModel(name: "circle_crunch", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    workoutToIdleScene: SceneModel(name: "situps_to_idle", radiusOrbitMul: 2.5, azimuth: .pi / 8, elevation: .pi / 4, scaledCenterMulX: 0, scaledCenterMulY: 0, scaledCenterMulZ: 0),
                    isWorkoutReversed: true)),
    ]
}
