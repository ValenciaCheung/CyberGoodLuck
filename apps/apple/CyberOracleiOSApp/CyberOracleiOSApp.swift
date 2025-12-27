import SwiftUI
import CyberOracleData

@main
struct CyberOracleiOSApp: App {
    @StateObject private var env = AppEnvironment(oracleService: LocalOracleService())

    var body: some Scene {
        WindowGroup {
            Text("CyberOracle")
                .environmentObject(env)
        }
    }
}

