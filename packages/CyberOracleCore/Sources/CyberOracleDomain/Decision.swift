import Foundation

public enum YesNo: String, Codable, Sendable {
    case yes = "YES"
    case no = "NO"
}

public struct DecisionResult: Codable, Equatable, Sendable {
    public let decidedAt: Date
    public let question: String?
    public let result: YesNo

    public init(decidedAt: Date, question: String?, result: YesNo) {
        self.decidedAt = decidedAt
        self.question = question
        self.result = result
    }
}

