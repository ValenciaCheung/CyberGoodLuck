import SwiftUI
import Combine
import AVKit
import AVFoundation
import CyberOracleDomain
import CyberOracleData

/// Daily Luck screen - 4-phase interactive flow with Maneki-neko animation
/// Phase 1: Prayer (shake to start)
/// Phase 2: Animating (Maneki-neko video)
/// Phase 3: Coin reveal (千万两)
/// Phase 4: Result (2x2 grid with tier cats and metric icons)
struct DailyLuckView: View {
    @EnvironmentObject private var env: AppEnvironment
    @StateObject private var viewModel: DailyLuckViewModel
    @StateObject private var shakeDetector = ShakeDetector()
    @StateObject private var videoPlayerHelper = VideoPlayerHelper()

    @State private var uiState: UIState = .prayer
    @State private var currentDate = Date()
    @State private var hapticTimer: Timer?
    @State private var coinScale: CGFloat = 0.5

    // Timer to check for midnight refresh
    let midnightCheckTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    enum UIState {
        case prayer        // Waiting for shake
        case animating     // Playing video animation
        case coinReveal    // Show 千万两 coin
        case result        // Show 2x2 grid
    }

    init() {
        // Temporary placeholder - will be injected via environment
        _viewModel = StateObject(wrappedValue: DailyLuckViewModel(
            oracleService: LocalOracleService()
        ))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Content based on UI state
            switch uiState {
            case .prayer:
                prayerView
            case .animating:
                animatingView
            case .coinReveal:
                coinRevealView
            case .result:
                if case .loaded(let luck) = viewModel.state {
                    resultView(luck: luck)
                } else if case .failed = viewModel.state {
                    errorView
                }
            }
        }
        .onAppear {
            shakeDetector.startDetecting()
            setupVideoPlayer()
        }
        .onDisappear {
            shakeDetector.stopDetecting()
            videoPlayerHelper.cleanup()
            hapticTimer?.invalidate()
        }
        .onChange(of: shakeDetector.isShaking) { oldValue, newValue in
            if newValue && uiState == .prayer {
                startShakeFlow()
            }
        }
        .onReceive(midnightCheckTimer) { _ in
            // Only refresh if in result state
            if uiState == .result {
                checkAndRefreshIfNewDay()
            }
        }
    }

    // MARK: - Phase 1: Prayer

    @ViewBuilder
    private var prayerView: some View {
        ZStack {
            // Prayer hands image - fill screen
            Image("DL_Prayer")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(shakeDetector.shakeIntensity > 0 ? 0.7 : 1.0)

            // DEBUG: Simulator button (shake not available on watchOS simulator)
            #if targetEnvironment(simulator)
            VStack {
                Spacer()
                Button(action: {
                    startShakeFlow()
                }) {
                    Text("TAP (Simulator)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(cyan.opacity(0.7))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(cyan.opacity(0.5), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .padding(.bottom, 8)
            }
            #endif
        }
    }

    // MARK: - Phase 2: Animating

    @ViewBuilder
    private var animatingView: some View {
        // Video player for Maneki-neko animation - fill screen
        if let player = videoPlayerHelper.player {
            VideoPlayer(player: player)
                .ignoresSafeArea()
                .onAppear {
                    videoPlayerHelper.play()
                    startHapticFeedback()
                }
        } else {
            // Fallback loading indicator
            ProgressView()
                .tint(neonGreen)
        }
    }

    // MARK: - Phase 3: Coin Reveal

    @ViewBuilder
    private var coinRevealView: some View {
        // 千万两 coin with scale animation - fill screen
        Image("DL_Coin")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .scaleEffect(coinScale)
            .onAppear {
                // Bounce in animation
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    coinScale = 1.0
                }
                HapticEngine.shared.playSuccess()

                // Auto-transition to result after 1.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showResult()
                }
            }
    }

    // MARK: - Phase 4: Result (2x2 Grid)

    @ViewBuilder
    private func resultView(luck: DailyLuck) -> some View {
        ZStack {
            // Background with labels (Love, Wealth, Career, Health) - fill screen
            Image("DL_ResultBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // 2x2 Grid overlay
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    // Top-left: Love
                    metricCell(metric: .love, tier: luck.metrics[.love] ?? .good)
                    // Top-right: Wealth
                    metricCell(metric: .money, tier: luck.metrics[.money] ?? .good)
                }
                HStack(spacing: 4) {
                    // Bottom-left: Career
                    metricCell(metric: .career, tier: luck.metrics[.career] ?? .good)
                    // Bottom-right: Health
                    metricCell(metric: .health, tier: luck.metrics[.health] ?? .good)
                }
            }
            .padding(20)

            // Date display at top
            VStack {
                Text(formattedDate)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 8)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            resetToPrayer()
        }
    }

    // MARK: - Metric Cell (for 2x2 grid)

    @ViewBuilder
    private func metricCell(metric: DailyLuckMetric, tier: DailyLuckTier) -> some View {
        ZStack(alignment: .bottomTrailing) {
            // Tier cat image (center)
            tierImage(for: tier)
                .resizable()
                .scaledToFit()

            // Metric icon (bottom-right corner)
            metricIcon(for: metric)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    // MARK: - Actions

    private func setupVideoPlayer() {
        videoPlayerHelper.setupPlayer(videoName: "jimeng-2025-12-27-8243", fileExtension: "mp4") { [self] in
            // Video completed - show coin reveal
            showCoinReveal()
        }
    }

    private func startShakeFlow() {
        uiState = .animating
        HapticEngine.shared.playStart()

        // Load data in background
        Task {
            await viewModel.refresh()
        }
    }

    private func startHapticFeedback() {
        // Play haptic every 0.5 seconds during animation
        var hapticCount = 0
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            HapticEngine.shared.playCatShake()
            hapticCount += 1

            // Limit to ~8 haptics (4 seconds of video)
            if hapticCount >= 8 {
                self.hapticTimer?.invalidate()
            }
        }
    }

    @MainActor
    private func showCoinReveal() {
        // Stop haptics
        hapticTimer?.invalidate()

        // Reset coin scale for animation
        coinScale = 0.5

        uiState = .coinReveal
    }

    @MainActor
    private func showResult() {
        // Ensure data is loaded
        guard case .loaded = viewModel.state else {
            // Data not ready yet, retry after short delay
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
                showResult()
            }
            return
        }

        uiState = .result

        // Entrance animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            // Can add scale or opacity animations here if needed
        }
    }

    private func resetToPrayer() {
        uiState = .prayer
        videoPlayerHelper.stop()
        hapticTimer?.invalidate()
        coinScale = 0.5
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

    /// Get tier cat image based on tier
    private func tierImage(for tier: DailyLuckTier) -> Image {
        switch tier {
        case .great: return Image("DL_TierGreat")  // Group-2.png - 极好 (happy cat)
        case .good: return Image("DL_TierGood")    // Group-1.png - 尚可 (neutral cat)
        case .ok: return Image("DL_TierGood")      // Group-1.png - 尚可 (map ok to good)
        case .bad: return Image("DL_TierBad")      // Group.png - 较差 (sad cat)
        }
    }

    /// Get metric icon based on metric type
    private func metricIcon(for metric: DailyLuckMetric) -> Image {
        switch metric {
        case .love: return Image("DL_IconLove")       // Image-3.png - heart
        case .money: return Image("DL_IconWealth")    // Image-2.png - coins
        case .career: return Image("DL_IconCareer")   // Image.png - briefcase
        case .health: return Image("DL_IconHealth")   // Image-1.png - medical
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: currentDate)
    }

    // MARK: - Colors

    private var neonGreen: Color {
        Color(red: 0/255, green: 255/255, blue: 65/255) // #00FF41
    }

    private var cyan: Color {
        Color(red: 0/255, green: 255/255, blue: 255/255) // #00FFFF
    }
}

#Preview {
    DailyLuckView()
        .environmentObject(AppEnvironment())
}
