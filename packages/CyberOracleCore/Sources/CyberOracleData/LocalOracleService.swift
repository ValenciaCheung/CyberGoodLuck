import Foundation
import CyberOracleDomain

public enum LocalOracleServiceError: Error, Equatable {
    case missingLevels
}

public final class LocalOracleService: OracleService, @unchecked Sendable {
    private let dateProvider: DateProviding
    private let configLoader: FortuneLevelsConfigLoader
    private let determinism: OracleDeterminism
    private let dailyLuckGenerator: DailyLuckGenerator
    private let fortuneDrawer: FortuneDrawer
    private let calendar: Calendar

    private var cachedConfig: FortuneLevelsConfig?

    public init(
        dateProvider: DateProviding = SystemDateProvider(),
        configLoader: FortuneLevelsConfigLoader = FortuneLevelsConfigLoader(),
        determinism: OracleDeterminism = OracleDeterminism(),
        dailyLuckGenerator: DailyLuckGenerator = DailyLuckGenerator(),
        fortuneDrawer: FortuneDrawer = FortuneDrawer(),
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.dateProvider = dateProvider
        self.configLoader = configLoader
        self.determinism = determinism
        self.dailyLuckGenerator = dailyLuckGenerator
        self.fortuneDrawer = fortuneDrawer
        self.calendar = calendar
    }

    public func fortuneLevels() async throws -> FortuneLevelsConfig {
        if let cachedConfig { return cachedConfig }
        let loaded = try configLoader.loadBundledConfig()
        cachedConfig = loaded
        return loaded
    }

    public func dailyLuck(for date: Date) async throws -> DailyLuck {
        let seed = determinism.daySeed(for: date, calendar: calendar)
        return dailyLuckGenerator.generate(for: date, seed: seed, calendar: calendar)
    }

    public func decideYesNo(question: String?, at date: Date) async throws -> DecisionResult {
        let daySeed = determinism.daySeed(for: date, calendar: calendar)
        let qSeed = determinism.hashSeed(question ?? "")
        let combined = determinism.combine(daySeed, qSeed)

        var rng = SplitMix64(seed: combined.value)
        let result: YesNo = rng.nextUnitInterval() < 0.5 ? .yes : .no
        return DecisionResult(decidedAt: date, question: question, result: result)
    }

    public func drawFortune(at date: Date) async throws -> FortuneDraw {
        let config = try await fortuneLevels()
        guard !config.levels.isEmpty else { throw LocalOracleServiceError.missingLevels }
        let seed = determinism.daySeed(for: date, calendar: calendar)
        return fortuneDrawer.draw(at: date, levels: config.levels, seed: seed)
    }
}

