import Foundation

public enum DailyLuckMetric: String, Codable, CaseIterable, Sendable {
    case love = "LOVE"
    case money = "MONEY"
    case career = "CAREER"
    case health = "HEALTH"
}

public enum DailyLuckTier: Int, Codable, Comparable, Sendable {
    case great = 1
    case good = 2
    case ok = 3
    case bad = 4

    public static func < (lhs: DailyLuckTier, rhs: DailyLuckTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

public struct DailyLuck: Codable, Equatable, Sendable {
    public let date: Date
    public let metrics: [DailyLuckMetric: DailyLuckTier]

    public init(date: Date, metrics: [DailyLuckMetric: DailyLuckTier]) {
        self.date = date
        self.metrics = metrics
    }
}

