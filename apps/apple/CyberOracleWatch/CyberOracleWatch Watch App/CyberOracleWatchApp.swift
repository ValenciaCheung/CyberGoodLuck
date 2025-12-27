import SwiftUI
import CyberOracleData

@main
struct CyberOracleWatchApp: App {
    @StateObject private var env = AppEnvironment(oracleService: LocalOracleService())

    var body: some Scene {
        WindowGroup {
            RootNavigationView()
                .environmentObject(env)
        }
    }
}

