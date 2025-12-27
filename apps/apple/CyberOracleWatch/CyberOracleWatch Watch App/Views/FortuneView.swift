import SwiftUI
import Combine
import CyberOracleDomain
import CyberOracleData

/// Fortune Sticks screen - Electronic divination
/// 4 stages: Idle (shake prompt) → Shaking (haptics) → Dropping (animation) → Reveal (fortune)
struct FortuneView: View {
    @EnvironmentObject private var env: AppEnvironment
    @StateObject private var viewModel: FortuneStickViewModel
    @StateObject private var shakeDetector = ShakeDetector()

    @State private var uiState: UIState = .idle
    @State private var stickRotation: Double = 0
    @State private var stickOffset: CGFloat = 0
    @State private var stickScale: CGFloat = 1.0
    @State private var opacity: Double = 1.0

    enum UIState {
        case idle          // Waiting for shake
        case shaking       // Shake detected, visual feedback
        case dropping      // Stick drops from container
        case revealed      // Show fortune result
    }

    init() {
        // Initialize with LocalOracleService
        _viewModel = StateObject(wrappedValue: FortuneStickViewModel(
            oracleService: LocalOracleService()
        ))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 12) {
                    // Title
                    Text("FORTUNE")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(cyan)

                    // Content based on UI state
                    switch uiState {
                    case .idle:
                        idleView
                    case .shaking:
                        shakingView
                    case .dropping:
                        droppingView
                    case .revealed:
                        if case .loaded(let fortune) = viewModel.state {
                            revealedView(fortune: fortune)
                        } else if case .failed = viewModel.state {
                            errorView
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            shakeDetector.startDetecting()
        }
        .onDisappear {
            shakeDetector.stopDetecting()
        }
        .onChange(of: shakeDetector.isShaking) { oldValue, newValue in
            if newValue && uiState == .idle {
                startShaking()
            }
        }
    }

    // MARK: - Stage 1: Idle

    @ViewBuilder
    private var idleView: some View {
        VStack(spacing: 12) {
            // Stick container (cylinder representation)
            ZStack {
                // Container outline
                RoundedRectangle(cornerRadius: 6)
                    .stroke(cyan.opacity(0.5), lineWidth: 2)
                    .frame(width: 60, height: 70)

                // Sticks inside (represented by vertical lines)
                VStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { _ in
                        Rectangle()
                            .fill(neonGreen.opacity(0.6))
                            .frame(width: 2, height: 45)
                    }
                }
            }

            // DEBUG: Simulator button (shake not available on watchOS simulator)
            #if targetEnvironment(simulator)
            Button(action: {
                startShaking()
            }) {
                VStack(spacing: 4) {
                    Text("TAP HERE")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(cyan)
                    Text("(Simulator Only)")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(cyan, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            #else
            Text("Shake it")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.gray)
            #endif

            // Shake intensity indicator
            if shakeDetector.shakeIntensity > 0 {
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index < Int(shakeDetector.shakeIntensity * 2) ? neonGreen : Color.gray.opacity(0.3))
                            .frame(width: 20, height: 4)
                    }
                }
            }
        }
    }

    // MARK: - Stage 2: Shaking

    @ViewBuilder
    private var shakingView: some View {
        VStack(spacing: 12) {
            // Vibrating container
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(cyan.opacity(0.5), lineWidth: 2)
                    .frame(width: 60, height: 70)
                    .offset(x: stickOffset)

                // Sticks shaking
                VStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { _ in
                        Rectangle()
                            .fill(neonGreen.opacity(0.6))
                            .frame(width: 2, height: 45)
                    }
                }
                .offset(x: stickOffset)
            }

            Text("Shaking...")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(cyan)
        }
    }

    // MARK: - Stage 3: Dropping

    @ViewBuilder
    private var droppingView: some View {
        VStack(spacing: 12) {
            // Single stick falling
            Rectangle()
                .fill(neonGreen)
                .frame(width: 3, height: 50)
                .rotationEffect(.degrees(stickRotation))
                .offset(y: stickOffset)
                .scaleEffect(stickScale)

            Text("Drawing...")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(cyan)
        }
    }

    // MARK: - Stage 4: Revealed

    @ViewBuilder
    private func revealedView(fortune: FortuneDraw) -> some View {
        VStack(spacing: 12) {
            // Fortune emoji
            Text(fortune.level.emoji)
                .font(.system(size: 50))
                .scaleEffect(stickScale)

            // Fortune label
            Text(fortune.level.label)
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(colorForLevel(fortune.level.key))

            // Fortune copy text
            Text(fortune.copy)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.8)

            // Timestamp
            Text(formattedTime(fortune.drawnAt))
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(.gray)

            // Tap hint
            Text("Tap to retry")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(neonGreen.opacity(0.5))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            resetFortune()
        }
    }

    private var errorView: some View {
        VStack(spacing: 8) {
            Text("⚠️")
                .font(.system(size: 32))
            Text("Failed to draw")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.red)
        }
    }

    // MARK: - Actions

    private func startShaking() {
        uiState = .shaking
        HapticEngine.shared.playStickCollision()

        // Shake animation
        withAnimation(.linear(duration: 0.1).repeatCount(8, autoreverses: true)) {
            stickOffset = 5
        }

        // Play collision haptics repeatedly
        for i in 0..<8 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                HapticEngine.shared.playStickCollision()
            }
        }

        // After shaking, transition to dropping
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            startDropping()
        }
    }

    private func startDropping() {
        uiState = .dropping
        stickOffset = -50
        stickRotation = 0

        // Drop animation
        withAnimation(.easeIn(duration: 0.6)) {
            stickOffset = 20
            stickRotation = 15
        }

        HapticEngine.shared.playStickDrop()

        // Call fortune draw API
        Task {
            await viewModel.draw()

            // Wait for drop animation to complete
            try? await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds

            // Show result
            revealFortune()
        }
    }

    @MainActor
    private func revealFortune() {
        uiState = .revealed

        // Reset animation values
        stickOffset = 0
        stickRotation = 0
        stickScale = 0.5

        if case .loaded(let fortune) = viewModel.state {
            // Play fortune-specific haptic
            let isSpecial = fortune.level.key == .ultra || fortune.level.key == .error
            HapticEngine.shared.playFortuneReveal(isSpecial: isSpecial)

            // Entrance animation
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                stickScale = 1.0
            }

            // Special effect for ULTRA
            if fortune.level.key == .ultra {
                // Flash effect
                withAnimation(.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true)) {
                    opacity = 0.5
                }
            }

            // Special effect for ERROR
            if fortune.level.key == .error {
                // Glitch/shake effect
                withAnimation(.linear(duration: 0.05).repeatCount(6, autoreverses: true)) {
                    stickOffset = 3
                }
            }
        }
    }

    private func resetFortune() {
        viewModel.reset()
        uiState = .idle
        stickOffset = 0
        stickRotation = 0
        stickScale = 1.0
        opacity = 1.0
    }

    // MARK: - Helper Functions

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }

    private func colorForLevel(_ key: FortuneLevelKey) -> Color {
        switch key {
        case .ultra:
            return Color(red: 255/255, green: 215/255, blue: 0/255) // Gold #FFD700
        case .superLevel:
            return Color(red: 0/255, green: 255/255, blue: 65/255) // Neon green #00FF41
        case .basic:
            return Color(red: 0/255, green: 160/255, blue: 255/255) // Blue #00A0FF
        case .glitch:
            return Color(red: 255/255, green: 193/255, blue: 7/255) // Yellow #FFC107
        case .error:
            return Color(red: 255/255, green: 45/255, blue: 85/255) // Red #FF2D55
        }
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
    FortuneView()
        .environmentObject(AppEnvironment())
}
