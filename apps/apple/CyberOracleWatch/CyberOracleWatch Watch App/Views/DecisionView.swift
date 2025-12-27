import SwiftUI
import Combine
import CyberOracleDomain
import CyberOracleData

/// Decision Maker screen - Yes/No decision with shake gesture
/// 3 stages: Prayer (waiting for shake) → Tossing (animation) → Result (YES/NO)
struct DecisionView: View {
    @EnvironmentObject private var env: AppEnvironment
    @StateObject private var viewModel: DecisionViewModel
    @StateObject private var shakeDetector = ShakeDetector()

    @State private var uiState: UIState = .prayer
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0

    enum UIState {
        case prayer        // Waiting for shake
        case tossing       // Coin flip animation
        case result        // Show YES/NO
    }

    init() {
        // Initialize with LocalOracleService (will be replaced by environment injection)
        _viewModel = StateObject(wrappedValue: DecisionViewModel(
            oracleService: LocalOracleService()
        ))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                // Title
                Text("DECISION")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(neonGreen)

                Spacer()

                // Content based on UI state
                switch uiState {
                case .prayer:
                    prayerView
                case .tossing:
                    tossingView
                case .result:
                    if case .loaded(let decision) = viewModel.state {
                        resultView(decision: decision)
                    } else if case .failed = viewModel.state {
                        errorView
                    }
                }

                Spacer()

                // Reset button (only show after result)
                if uiState == .result {
                    Button(action: resetDecision) {
                        Text("Again")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(neonGreen)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .onAppear {
            shakeDetector.startDetecting()
        }
        .onDisappear {
            shakeDetector.stopDetecting()
        }
        .onChange(of: shakeDetector.isShaking) { oldValue, newValue in
            if newValue && uiState == .prayer {
                startToss()
            }
        }
    }

    // MARK: - Stage 1: Prayer

    @ViewBuilder
    private var prayerView: some View {
        VStack(spacing: 16) {
            // Praying hands emoji
            Text("🙏")
                .font(.system(size: 60))
                .opacity(shakeDetector.shakeIntensity > 0 ? 0.7 : 1.0)

            // Prompt
            Text("Shake it")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.gray)

            // Shake intensity indicator (visual feedback)
            if shakeDetector.shakeIntensity > 0 {
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index < Int(shakeDetector.shakeIntensity * 2) ? neonGreen : Color.gray.opacity(0.3))
                            .frame(width: 20, height: 4)
                    }
                }
            }

            // DEBUG: Simulator button (shake not available on watchOS simulator)
            #if targetEnvironment(simulator)
            Button(action: {
                startToss()
            }) {
                Text("TAP (Simulator)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(cyan.opacity(0.7))
            }
            .buttonStyle(.plain)
            #endif
        }
    }

    // MARK: - Stage 2: Tossing

    @ViewBuilder
    private var tossingView: some View {
        VStack(spacing: 16) {
            // Coin flip animation
            Text("💫")
                .font(.system(size: 60))
                .rotationEffect(.degrees(rotationAngle))
                .scaleEffect(scale)

            Text("Deciding...")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(cyan)
        }
    }

    // MARK: - Stage 3: Result

    @ViewBuilder
    private func resultView(decision: DecisionResult) -> some View {
        VStack(spacing: 16) {
            // Result emoji
            Text(decision.result == .yes ? "✅" : "❌")
                .font(.system(size: 60))
                .scaleEffect(scale)

            // Result text
            Text(decision.result == .yes ? "YES" : "NO")
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .foregroundColor(decision.result == .yes ? successGreen : errorRed)

            // Timestamp
            Text(formattedTime(decision.decidedAt))
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.gray)
        }
    }

    private var errorView: some View {
        VStack(spacing: 8) {
            Text("⚠️")
                .font(.system(size: 32))
            Text("Failed")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.red)
        }
    }

    // MARK: - Actions

    private func startToss() {
        // Transition to tossing state
        uiState = .tossing
        HapticEngine.shared.playCoinFlip()

        // Start coin flip animation
        withAnimation(.linear(duration: 1.0).repeatCount(3, autoreverses: false)) {
            rotationAngle = 360 * 3
        }
        withAnimation(.easeInOut(duration: 0.3).repeatCount(6, autoreverses: true)) {
            scale = 1.2
        }

        // Call decision API
        Task {
            await viewModel.decide(question: nil)

            // Wait for animation to complete
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

            // Show result
            await showResult()
        }
    }

    @MainActor
    private func showResult() {
        uiState = .result

        // Reset animation values
        rotationAngle = 0
        scale = 1.0

        // Play result haptic
        if case .loaded(let decision) = viewModel.state {
            if decision.result == .yes {
                HapticEngine.shared.playSuccess()
            } else {
                HapticEngine.shared.playFailure()
            }

            // Entrance animation
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
    }

    private func resetDecision() {
        viewModel.reset()
        uiState = .prayer
        rotationAngle = 0
        scale = 1.0
    }

    // MARK: - Helper Functions

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }

    // MARK: - Colors

    private var neonGreen: Color {
        Color(red: 0/255, green: 255/255, blue: 65/255) // #00FF41
    }

    private var cyan: Color {
        Color(red: 0/255, green: 255/255, blue: 255/255) // #00FFFF
    }

    private var successGreen: Color {
        Color(red: 0/255, green: 255/255, blue: 65/255) // #00FF41
    }

    private var errorRed: Color {
        Color(red: 255/255, green: 60/255, blue: 60/255) // #FF003C
    }
}

#Preview {
    DecisionView()
        .environmentObject(AppEnvironment())
}
