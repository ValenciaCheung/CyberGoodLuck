import Foundation

public protocol OracleService: Sendable {
    func fortuneLevels() async throws -> FortuneLevelsConfig
    func dailyLuck(for date: Date) async throws -> DailyLuck
    func decideYesNo(question: String?, at date: Date) async throws -> DecisionResult
    func drawFortune(at date: Date) async throws -> FortuneDraw
}

