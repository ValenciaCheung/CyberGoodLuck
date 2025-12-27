import Foundation
import Combine
import CyberOracleDomain

@MainActor
public final class DecisionViewModel: ObservableObject {
    @Published public private(set) var state: State = .idle

    private let oracleService: OracleService
    private let dateProvider: () -> Date

    public init(oracleService: OracleService, dateProvider: @escaping () -> Date = { Date() }) {
        self.oracleService = oracleService
        self.dateProvider = dateProvider
    }

    public func decide(question: String?) async {
        state = .loading
        do {
            let decision = try await oracleService.decideYesNo(question: question, at: dateProvider())
            state = .loaded(decision)
        } catch {
            state = .failed
        }
    }

    public enum State: Equatable {
        case idle
        case loading
        case loaded(DecisionResult)
        case failed
    }
}
