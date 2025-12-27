import Foundation
import Combine
import CyberOracleDomain

@MainActor
public final class DailyLuckViewModel: ObservableObject {
    @Published public private(set) var state: State = .idle

    private let oracleService: OracleService
    private let dateProvider: () -> Date

    public init(oracleService: OracleService, dateProvider: @escaping () -> Date = { Date() }) {
        self.oracleService = oracleService
        self.dateProvider = dateProvider
    }

    public func refresh() async {
        state = .loading
        do {
            let luck = try await oracleService.dailyLuck(for: dateProvider())
            state = .loaded(luck)
        } catch {
            state = .failed
        }
    }

    public enum State: Equatable {
        case idle
        case loading
        case loaded(DailyLuck)
        case failed
    }
}
