//
//  CalisCoreTests.swift
//  CalisCoreTests
//
//  Created by  Alexander Fedoseev on 23.09.2026.
//

import XCTest
@testable import CalisCore

@MainActor
final class CalisCoreTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: - Диапазоны из констант

    /// Диапазон длительностей в секундах, с шагом 1 минута (30...90 мин → 1800...5400 сек)
    private var durationRangeSeconds: [Int] {
        let step = 60
        let minS = WorkoutModelConstants.workoutDurationMin * step
        let maxS = WorkoutModelConstants.workoutDurationMax * step
        return Array(stride(from: minS, through: maxS, by: step))
    }

    /// Диапазон количеств упражнений: от exercisesCountMin до размера базы DataSource
    private var exercisesCountRange: [Int] {
        let minC = WorkoutModelConstants.exercisesCountMin
        let maxC = DataSource.exercises.count
        return Array(minC...maxC)
    }

    private let allTypes: [WorkoutType] = [.strength, .endurance, .explosivePower, .circuit]

    // MARK: - Все комбинации (полный перебор)

    /// Полный перебор: длительность × число упражнений × тип.
    /// Шаг длительности — 1 минута, диапазон counts — от min до размера базы.
    func testAllCombinations_BaseInvariants() async throws {
        let durations = durationRangeSeconds
        let counts = exercisesCountRange

        for type in allTypes {
            for duration in durations {
                for count in counts {
                    let dm = DataManager(totalDuration: duration, userExercisesCount: count, workoutType: type)
                    let models = dm.getWorkoutExercises()
                    XCTAssertFalse(models.isEmpty, "Пустой план: type=\(type), dur=\(duration), count=\(count)")
                    if type != .circuit {
                        XCTAssertEqual(models.count, count, "type=\(type), dur=\(duration), count=\(count)")
                    } else {
                        XCTAssertEqual(models.count % count, 0, "circuit: \(models.count) не кратно \(count)")
                        let cycles = models.count / count
                        XCTAssertTrue((1...7).contains(cycles), "cycles=\(cycles) вне [1,7]")
                    }
                    for model in models {
                        assertCommonInvariants(model, type: type, duration: duration, count: count)
                    }
                }
            }
        }
    }

    /// Общие инварианты для одного упражнения
    private func assertCommonInvariants(_ model: ExerciseModel, type: WorkoutType, duration: Int, count: Int, file: StaticString = #file, line: UInt = #line) {
        let ctx = "type=\(type), dur=\(duration), count=\(count), exIdx=\(model.index)"

        // setDuration: положительный и кратен 5
        XCTAssertGreaterThan(model.setDuration, 0, "setDuration <= 0 — \(ctx)", file: file, line: line)
        XCTAssertEqual(model.setDuration % 5, 0, "setDuration=\(model.setDuration) не кратен 5 — \(ctx)", file: file, line: line)

        // setsCount >= 1
        XCTAssertGreaterThanOrEqual(model.setsCount, 1, "setsCount=\(model.setsCount) < 1 — \(ctx)", file: file, line: line)

        // steps: ровно setsCount пар (set+rest) [+ опциональный circuitRest]
        let setSteps = model.steps.filter { $0.kind == .setDuration }
        let restSteps = model.steps.filter { $0.kind == .restDuration }
        let circuitSteps = model.steps.filter { $0.kind == .circuitRestDuration }
        XCTAssertEqual(setSteps.count, model.setsCount, "setSteps != setsCount — \(ctx)", file: file, line: line)
        XCTAssertEqual(restSteps.count, model.setsCount, "restSteps != setsCount — \(ctx)", file: file, line: line)
        XCTAssertLessThanOrEqual(circuitSteps.count, 1, "circuitRest шагов > 1 — \(ctx)", file: file, line: line)

        // exerciseDuration = сумма шагов
        let sum = model.steps.reduce(0) { $0 + $1.duration }
        XCTAssertEqual(model.exerciseDuration, sum, "exerciseDuration != сумма шагов — \(ctx)", file: file, line: line)

        // Все шаги > 0
        for step in model.steps {
            XCTAssertGreaterThan(step.duration, 0, "step.duration=\(step.duration) (\(step.kind)) — \(ctx)", file: file, line: line)
        }

        // Начальное состояние
        XCTAssertEqual(model.currentState, .begin, "currentState != .begin — \(ctx)", file: file, line: line)
        XCTAssertEqual(model.currentPhase, .idle, "currentPhase != .idle — \(ctx)", file: file, line: line)
        XCTAssertEqual(model.progress, 0, "progress != 0 — \(ctx)", file: file, line: line)
    }

    // MARK: - Диапазоны setDuration по типам

    func testSetDurationInRangeForEachType() async throws {
        let ranges: [WorkoutType: ClosedRange<Int>] = [
            .strength: 45...90,
            .endurance: 60...120,
            .explosivePower: 15...30,
            .circuit: 40...60,
        ]
        for type in allTypes {
            for duration in durationRangeSeconds {
                let dm = DataManager(totalDuration: duration, userExercisesCount: 3, workoutType: type)
                for model in dm.getWorkoutExercises() {
                    XCTAssertTrue(ranges[type]!.contains(model.setDuration), "setDuration=\(model.setDuration) вне \(ranges[type]!) — " + "type=\(type), dur=\(duration)")
                }
            }
        }
    }

    // MARK: - recoveryDuration: формулы по типам

    func testRecoveryDurationFormulas() async throws {
        for _ in 0..<200 {
            for type in allTypes {
                let dm = DataManager(totalDuration: 3600, userExercisesCount: 3, workoutType: type)
                for model in dm.getWorkoutExercises() {
                    let expected: Int
                    switch type {
                    case .strength:       expected = model.setDuration
                    case .endurance:      expected = model.setDuration / 2
                    case .explosivePower: expected = model.setDuration * 2
                    case .circuit:        expected = model.setDuration / 3
                    }
                    XCTAssertEqual(model.recoveryDuration, expected, "recovery != expected для \(type): set=\(model.setDuration)")
                }
            }
        }
    }

    // MARK: - Уникальность выбора упражнений (внутри одного цикла)

    func testPickedExercisesUniqueWithinCycle() async throws {
        for type in allTypes {
            for duration in durationRangeSeconds {
                let count = 5
                let dm = DataManager(totalDuration: duration,
                                     userExercisesCount: count,
                                     workoutType: type)
                let models = dm.getWorkoutExercises()
                guard !models.isEmpty else { continue }

                if type == .circuit {
                    let cycles = models.count / count
                    for c in 0..<cycles {
                        let slice = Array(models[(c * count)..<((c + 1) * count)])
                        let ids = slice.map(\.id)
                        XCTAssertEqual(Set(ids).count, ids.count, "Дубликат id в цикле \(c) — type=\(type), dur=\(duration)")
                    }
                } else {
                    let ids = models.map(\.id)
                    XCTAssertEqual(Set(ids).count, ids.count, "Дубликат id — type=\(type), dur=\(duration)")
                }
            }
        }
    }

    // MARK: - Последовательность индексов

    func testIndicesAreSequential() async throws {
        for type in allTypes {
            for duration in durationRangeSeconds {
                let dm = DataManager(totalDuration: duration, userExercisesCount: 3, workoutType: type)
                let models = dm.getWorkoutExercises()
                for (i, model) in models.enumerated() {
                    XCTAssertEqual(model.index, i, "index=\(model.index), ожидался \(i) — type=\(type)")
                }
            }
        }
    }

    // MARK: - Границы диапазона количества упражнений

    func testMinExercisesCountWorks() async throws {
        let minC = WorkoutModelConstants.exercisesCountMin
        for type in allTypes {
            let dm = DataManager(totalDuration: 600, userExercisesCount: minC, workoutType: type)
            let models = dm.getWorkoutExercises()
            XCTAssertFalse(models.isEmpty, "type=\(type), min count")
        }
    }

    func testMaxExercisesCountWorks() async throws {
        let maxC = DataSource.exercises.count
        for type in allTypes {
            let dm = DataManager(totalDuration: 3600, userExercisesCount: maxC, workoutType: type)
            let models = dm.getWorkoutExercises()
            XCTAssertFalse(models.isEmpty, "type=\(type), max count")
            if type != .circuit {
                XCTAssertEqual(models.count, maxC)
            }
        }
    }

    func testTooManyExercisesReturnsEmpty() async throws {
        let tooMany = DataSource.exercises.count + 1
        for type in allTypes {
            let dm = DataManager(totalDuration: 3600, userExercisesCount: tooMany, workoutType: type)
            XCTAssertTrue(dm.getWorkoutExercises().isEmpty, "Ожидался пустой план для type=\(type)")
        }
    }

    func testZeroExercisesReturnsEmpty() async throws {
        for type in allTypes {
            let dm = DataManager(totalDuration: 3600, userExercisesCount: 0, workoutType: type)
            XCTAssertTrue(dm.getWorkoutExercises().isEmpty)
        }
    }

    // MARK: - Минимальная / максимальная длительность

    func testMinDurationProducesValidPlan() async throws {
        let minDur = WorkoutModelConstants.workoutDurationMin * 60
        for type in allTypes {
            let dm = DataManager(totalDuration: minDur, userExercisesCount: WorkoutModelConstants.exercisesCountMin, workoutType: type)
            let models = dm.getWorkoutExercises()
            XCTAssertFalse(models.isEmpty, "type=\(type), min duration")
            for model in models {
                XCTAssertGreaterThanOrEqual(model.setsCount, 1)
                XCTAssertGreaterThan(model.exerciseDuration, 0)
            }
        }
    }

    func testMaxDurationProducesValidPlan() async throws {
        let maxDur = WorkoutModelConstants.workoutDurationMax * 60
        for type in allTypes {
            let dm = DataManager(totalDuration: maxDur, userExercisesCount: WorkoutModelConstants.exercisesCountDefault, workoutType: type)
            let models = dm.getWorkoutExercises()
            XCTAssertFalse(models.isEmpty)
        }
    }

    // MARK: - Circuit: количество циклов в [1, 7]

    func testCircuitCyclesCountInRange() async throws {
        // Прогоняем много раз, чтобы поймать края randomTriangular
        for _ in 0..<300 {
            let count = 3
            let dm = DataManager(totalDuration: 3600, userExercisesCount: count, workoutType: .circuit)
            let models = dm.getWorkoutExercises()
            XCTAssertFalse(models.isEmpty)
            let cycles = models.count / count
            XCTAssertTrue((1...7).contains(cycles), "cycles=\(cycles) вне [1,7]")
            XCTAssertEqual(models.count % count, 0)
        }
    }

    func testCircuitRestBetweenCyclesIs60() async throws {
        for _ in 0..<100 {
            let count = 3
            let dm = DataManager(totalDuration: 3600,
                                 userExercisesCount: count,
                                 workoutType: .circuit)
            let models = dm.getWorkoutExercises()
            let withRest = models.filter { $0.steps.contains { $0.kind == .circuitRestDuration } }
            for model in withRest {
                guard let step = model.steps.first(where: { $0.kind == .circuitRestDuration }) else {
                    XCTFail("Ожидался circuitRestDuration")
                    continue
                }
                XCTAssertEqual(step.duration, 60)
            }
        }
    }

    func testCircuitLastExerciseHasNoCircuitRest() async throws {
        for _ in 0..<100 {
            let count = 3
            let dm = DataManager(totalDuration: 3600, userExercisesCount: count, workoutType: .circuit)
            let models = dm.getWorkoutExercises()
            guard let last = models.last else {
                XCTFail("Пустой план")
                continue
            }
            XCTAssertFalse(last.steps.contains { $0.kind == .circuitRestDuration },
                           "Последнее упражнение не должно иметь circuitRest")
        }
    }

    func testNonCircuitHasNoCircuitRestSteps() async throws {
        for type in [WorkoutType.strength, .endurance, .explosivePower] {
            for duration in durationRangeSeconds {
                let dm = DataManager(totalDuration: duration, userExercisesCount: 3, workoutType: type)
                for model in dm.getWorkoutExercises() {
                    XCTAssertFalse(model.steps.contains { $0.kind == .circuitRestDuration },
                                   "circuitRest не должен быть у \(type)")
                }
            }
        }
    }

    // MARK: - setsCount >= 1 на границах

    func testSetsCountAlwaysAtLeastOne() async throws {
        let shortest = WorkoutModelConstants.workoutDurationMin * 60
        let maxCount = DataSource.exercises.count

        for type in allTypes {
            let dm = DataManager(totalDuration: shortest, userExercisesCount: maxCount, workoutType: type)
            for model in dm.getWorkoutExercises() {
                XCTAssertGreaterThanOrEqual(model.setsCount, 1, "setsCount=\(model.setsCount) — type=\(type), " + "dur=\(shortest), count=\(maxCount)")
            }
        }
    }

    // MARK: - Общая сумма времени

    func testTotalDurationReasonable() async throws {
        for type in allTypes {
            for duration in durationRangeSeconds {
                let count = 4
                let dm = DataManager(totalDuration: duration,
                                     userExercisesCount: count,
                                     workoutType: type)
                let models = dm.getWorkoutExercises()
                let total = models.reduce(0) { $0 + $1.exerciseDuration }
                let maxAllowed = duration + count * 120
                XCTAssertLessThanOrEqual(total, maxAllowed, "Суммарное время \(total) сильно больше бюджета \(duration) — \(type)")
            }
        }
    }

    // MARK: - Все типы дают непустой план в нормальных условиях

    func testEveryTypeProducesNonEmptyPlanInNormalConditions() async throws {
        for type in allTypes {
            for duration in durationRangeSeconds {
                let dm = DataManager(totalDuration: duration,
                                     userExercisesCount: WorkoutModelConstants.exercisesCountDefault,
                                     workoutType: type)
                XCTAssertFalse(dm.getWorkoutExercises().isEmpty, "Пустой план — type=\(type), dur=\(duration)")
            }
        }
    }

    // MARK: - Перемешивание реально перемешивает

    func testTwoRunsProduceDifferentPicks() async throws {
        var seenDifferent = false
        for _ in 0..<50 {
            let dm1 = DataManager(totalDuration: 600, userExercisesCount: 3, workoutType: .strength)
            let dm2 = DataManager(totalDuration: 600, userExercisesCount: 3, workoutType: .strength)
            let ids1 = dm1.getWorkoutExercises().map(\.id)
            let ids2 = dm2.getWorkoutExercises().map(\.id)
            if ids1 != ids2 { seenDifferent = true; break }
        }
        XCTAssertTrue(seenDifferent, "shuffled() не даёт вариаций — что-то не так")
    }

    // MARK: - Каждый exerciseModel непустой по названию и описанию

    func testExerciseTitleAndDescriptionNonEmpty() async throws {
        let dm = DataManager(totalDuration: 600,
                             userExercisesCount: 3,
                             workoutType: .strength)
        for model in dm.getWorkoutExercises() {
            XCTAssertFalse(model.title.isEmpty, "title пустой")
            XCTAssertFalse(model.description.isEmpty, "description пустой")
        }
    }

    // MARK: - Длительность упражнения не меньше setDuration

    func testExerciseDurationAtLeastOneSet() async throws {
        for type in allTypes {
            for duration in durationRangeSeconds {
                let dm = DataManager(totalDuration: duration,
                                     userExercisesCount: 3,
                                     workoutType: type)
                for model in dm.getWorkoutExercises() {
                    XCTAssertGreaterThanOrEqual(model.exerciseDuration, model.setDuration, "exerciseDuration < setDuration — type=\(type)")
                }
            }
        }
    }
}
