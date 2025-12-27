import Foundation
import Combine
import CyberOracleDomain
import CyberOracleData

/// App-level environment for dependency injection
/// Provides the OracleService to all views via @EnvironmentObject
@MainActor
public final class AppEnvironment: ObservableObject {
    public let oracleService: OracleService

    public init(oracleService: OracleService = LocalOracleService()) {
        self.oracleService = oracleService
    }
}
