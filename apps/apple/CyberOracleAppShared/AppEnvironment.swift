import Foundation
import Combine
import CyberOracleDomain
import CyberOracleData

@MainActor
public final class AppEnvironment: ObservableObject {
    public let oracleService: OracleService

    public init(oracleService: OracleService = LocalOracleService()) {
        self.oracleService = oracleService
    }
}
