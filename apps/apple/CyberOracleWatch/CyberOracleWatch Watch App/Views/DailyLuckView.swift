import SwiftUI
import Combine
import CyberOracleDomain
import CyberOracleData

/// Daily Luck screen - displays 4 luck metrics
/// Shows Love, Money, Career, Health with tier-based emojis and colors
struct DailyLuckView: View {
    @EnvironmentObject private var env: AppEnvironment
    @StateObject private var viewModel: DailyLuckViewModel
    @State private var currentDate = Date()

    // Timer to check for midnight refresh
    let midnightCheckTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    init() {
        // Temporary placeholder - will be injected via environment
        _viewModel = StateObject(wrappedValue: DailyLuckViewModel(
            oracleService: LocalOracleService()
        ))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                // Title
                Text("DAILY LUCK")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(neonGreen)

                // Date display
                Text(formattedDate)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.gray)

                // Content based on state
                switch viewModel.state {
                case .idle:
                    loadingIndicator
                case .loading:
                    loadingIndicator
                case .loaded(let luck):
                    luckGrid(luck: luck)
                case .failed:
                    errorView
                }
            }
            .padding()
        }
        .task {
            // Load data when view appears
            await viewModel.refresh()
        }
        .onReceive(midnightCheckTimer) { _ in
            checkAndRefreshIfNewDay()
        }
    }

    // MARK: - Luck Grid (2x2)

    @ViewBuilder
    private func luckGrid(luck: DailyLuck) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                metricCard(metric: .love, tier: luck.metrics[.love] ?? .ok)
                metricCard(metric: .money, tier: luck.metrics[.money] ?? .ok)
            }
            HStack(spacing: 12) {
                metricCard(metric: .career, tier: luck.metrics[.career] ?? .ok)
                metricCard(metric: .health, tier: luck.metrics[.health] ?? .ok)
            }
        }
    }

    // MARK: - Metric Card

    @ViewBuilder
    private func metricCard(metric: DailyLuckMetric, tier: DailyLuckTier) -> some View {
        VStack(spacing: 4) {
            // Emoji for metric type
            Text(emoji(for: metric))
                .font(.system(size: 24))

            // Tier emoji (status)
            Text(tierEmoji(for: tier))
                .font(.system(size: 20))

            // Metric label
            Text(label(for: metric))
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundColor(color(for: tier))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color(for: tier).opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Loading & Error States

    private var loadingIndicator: some View {
        VStack(spacing: 8) {
            ProgressView()
                .tint(neonGreen)
            Text("Loading...")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.gray)
        }
    }

    private var errorView: some View {
        VStack(spacing: 8) {
            Text("⚠️")
                .font(.system(size: 32))
            Text("Failed to load")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.red)
        }
    }

    // MARK: - Midnight Refresh Logic

    private func checkAndRefreshIfNewDay() {
        let newDate = Date()
        let calendar = Calendar.current

        // Check if day changed
        if !calendar.isDate(currentDate, inSameDayAs: newDate) {
            currentDate = newDate
            Task {
                await viewModel.refresh()
            }
        }
    }

    // MARK: - Helper Functions

    private func emoji(for metric: DailyLuckMetric) -> String {
        switch metric {
        case .love: return "💗"
        case .money: return "💰"
        case .career: return "💼"
        case .health: return "❤️‍🩹"
        }
    }

    private func tierEmoji(for tier: DailyLuckTier) -> String {
        switch tier {
        case .great: return "🤩"  // Level 1 极好
        case .good: return "🙂"   // Level 2 尚可
        case .ok: return "😐"     // Level 3 一般
        case .bad: return "😵"    // Level 4 较差
        }
    }

    private func label(for metric: DailyLuckMetric) -> String {
        switch metric {
        case .love: return "LOVE"
        case .money: return "MONEY"
        case .career: return "CAREER"
        case .health: return "HEALTH"
        }
    }

    private func color(for tier: DailyLuckTier) -> Color {
        switch tier {
        case .great: return Color(red: 0/255, green: 255/255, blue: 65/255)   // Neon green
        case .good: return Color(red: 0/255, green: 160/255, blue: 255/255)   // Blue
        case .ok: return Color(red: 255/255, green: 200/255, blue: 0/255)     // Yellow
        case .bad: return Color(red: 255/255, green: 60/255, blue: 60/255)    // Red
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: currentDate)
    }

    private var neonGreen: Color {
        Color(red: 0/255, green: 255/255, blue: 65/255)
    }
}

#Preview {
    DailyLuckView()
        .environmentObject(AppEnvironment())
}
