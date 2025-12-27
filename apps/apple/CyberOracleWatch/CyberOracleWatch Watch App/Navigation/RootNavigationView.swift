import SwiftUI

/// Root navigation view for the watchOS app
/// Provides tab-based navigation between main screens
struct RootNavigationView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home screen (time HUD)
            HomeView()
                .tag(0)

            // Daily Luck
            DailyLuckView()
                .tag(1)

            // Decision Maker
            DecisionView()
                .tag(2)

            // Fortune Sticks
            FortuneView()
                .tag(3)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    RootNavigationView()
        .environmentObject(AppEnvironment())
}
