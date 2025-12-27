import Foundation
import Combine
import CyberOracleDomain
import CyberOracleData

@MainActor
public final class FortuneStickViewModel: ObservableObject {
    @Published public private(set) var state: State = .idle

    private let oracleService: OracleService
    private let dateProvider: () -> Date

    public init(oracleService: OracleService, dateProvider: @escaping () -> Date = { Date() }) {
        self.oracleService = oracleService
        self.dateProvider = dateProvider
    }

    public func draw() async {
        state = .loading
        do {
            let draw = try await oracleService.drawFortune(at: dateProvider())
            state = .loaded(draw)
        } catch {
            state = .failed
        }
    }

    public func reset() {
        state = .idle
    }

    public enum State: Equatable {
        case idle
        case loading
        case loaded(FortuneDraw)
        case failed
    }
}
