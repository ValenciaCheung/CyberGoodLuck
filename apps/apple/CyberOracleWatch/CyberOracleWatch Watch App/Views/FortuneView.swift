import SwiftUI
import Combine
import CyberOracleDomain
import CyberOracleData

/// Fortune Sticks screen - Electronic divination with Japanese folk art assets
/// 12 stages: Idle → Shake transition → PostShake → Decorated shake → Container transition →
/// Answer → Category reveal → Intermediate result → Daruma1 → Daruma transition → Daruma2 → Final result
struct FortuneView: View {
    @EnvironmentObject private var env: AppEnvironment
    @StateObject private var viewModel: FortuneStickViewModel
    @StateObject private var shakeDetector = ShakeDetector()

    // State machine (12 stages)
    @State private var flowState: FortuneFlowState = .idle

    // Fortune level selection (set after API call)
    @State private var selectedFortuneLevel: FortuneLevelKey?

    // Random selection for final image (1 of 5)
    @State private var selectedFinalIndex: Int = 0

    // Animation states
    @State private var shakeOffset: CGFloat = 0
    @State private var resultScale: CGFloat = 1.0

    // Task management for cancellation
    @State private var currentTask: Task<Void, Never>?

    /// 12-stage fortune flow state machine
    enum FortuneFlowState {
        case idle              // PNG 13 - "Shake" prompt
        case shakeTransition   // Video: fortune_shake_transition
        case postShake         // PNG 14 - Container without text
        case decoratedShake    // PNG 15 - Decorated container + shake animation
        case containerToAnswer // Video: fortune_container_to_answer
        case answerScreen      // PNG 16 - "answer" screen
        case categoryReveal    // PNG 17-21 - Fortune category based on level
        case intermediateResult // PNG 22-26 - 1:1 mapped to category
        case daruma1           // PNG 27 - First Daruma screen
        case darumaTransition  // Video: fortune_daruma_transition
        case daruma2           // PNG 28 - Second Daruma screen
        case finalResult       // PNG 29-33 - Random final fortune
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

                    // Content based on flow state (12 stages)
                    switch flowState {
                    case .idle:
                        staticImageView(imageName: "fortune_idle")
                            .overlay(alignment: .bottom) {
                                debugButton // Simulator button overlay
                            }

                    case .shakeTransition:
                        videoView(fileName: "fortune_shake_transition") {
                            transitionTo(.postShake)
                        }

                    case .postShake:
                        staticImageView(imageName: "fortune_postshake")
                            .onAppear { startPostShakeDelay() }

                    case .decoratedShake:
                        staticImageView(imageName: "fortune_decorated")
                            .offset(x: shakeOffset)
                            .onAppear { startShakeHaptics() }

                    case .containerToAnswer:
                        videoView(fileName: "fortune_container_to_answer") {
                            transitionTo(.answerScreen)
                        }

                    case .answerScreen:
                        staticImageView(imageName: "fortune_answer")
                            .onAppear { startAnswerDelay() }

                    case .categoryReveal:
                        staticImageView(imageName: categoryImageName())
                            .onAppear { startCategoryDelay() }

                    case .intermediateResult:
                        staticImageView(imageName: intermediateImageName())
                            .onAppear { startIntermediateDelay() }

                    case .daruma1:
                        staticImageView(imageName: "fortune_daruma1")
                            .onAppear { startDaruma1Delay() }

                    case .darumaTransition:
                        videoView(fileName: "fortune_daruma_transition") {
                            transitionTo(.daruma2)
                        }

                    case .daruma2:
                        staticImageView(imageName: "fortune_daruma2")
                            .onAppear { startDaruma2Delay() }

                    case .finalResult:
                        staticImageView(imageName: finalImageName())
                            .scaleEffect(resultScale)
                            .onAppear { showFinalResult() }
                            .onTapGesture { resetFortune() }
                            .overlay(alignment: .bottom) {
                                Text("Tap to retry")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(neonGreen.opacity(0.5))
                                    .padding(.bottom, 20)
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
            currentTask?.cancel()
        }
        .onChange(of: shakeDetector.isShaking) { oldValue, newValue in
            if newValue && flowState == .idle {
                transitionTo(.shakeTransition)
            }
        }
    }

    // MARK: - View Builders

    @ViewBuilder
    private func staticImageView(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func videoView(fileName: String, onComplete: @escaping () -> Void) -> some View {
        VideoPlayerView(
            videoFileName: fileName,
            onComplete: onComplete,
            fallbackImage: nil
        )
    }

    @ViewBuilder
    private var debugButton: some View {
        #if targetEnvironment(simulator)
        Button(action: {
            if flowState == .idle {
                transitionTo(.shakeTransition)
            }
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
                    .fill(Color.black.opacity(0.7))
            )
        }
        .buttonStyle(.plain)
        .padding(.bottom, 20)
        #else
        EmptyView()
        #endif
    }

    // MARK: - Image Name Mapping

    private func categoryImageName() -> String {
        guard let level = selectedFortuneLevel else {
            return "fortune_basic" // Fallback
        }

        switch level {
        case .ultra: return "fortune_ultra"
        case .superLevel: return "fortune_super"
        case .basic: return "fortune_basic"
        case .glitch: return "fortune_glitch"
        case .error: return "fortune_error"
        }
    }

    private func intermediateImageName() -> String {
        guard let level = selectedFortuneLevel else {
            return "fortune_basic_intermediate"
        }

        switch level {
        case .ultra: return "fortune_ultra_intermediate"
        case .superLevel: return "fortune_super_intermediate"
        case .basic: return "fortune_basic_intermediate"
        case .glitch: return "fortune_glitch_intermediate"
        case .error: return "fortune_error_intermediate"
        }
    }

    private func finalImageName() -> String {
        return "fortune_final_\(selectedFinalIndex + 1)" // 1-5
    }

    // MARK: - State Transitions

    private func transitionTo(_ newState: FortuneFlowState) {
        print("🎴 Fortune: \(flowState) → \(newState)")
        flowState = newState
    }

    private func startPostShakeDelay() {
        currentTask?.cancel()
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
            if !Task.isCancelled {
                transitionTo(.decoratedShake)
            }
        }
    }

    private func startShakeHaptics() {
        // Play 8 collision haptics
        for i in 0..<8 {
            Task {
                try? await Task.sleep(nanoseconds: UInt64(Double(i) * 0.1 * 1_000_000_000))
                if !Task.isCancelled {
                    HapticEngine.shared.playStickCollision()
                }
            }
        }

        // Shake animation
        withAnimation(.linear(duration: 0.1).repeatCount(8, autoreverses: true)) {
            shakeOffset = 5
        }

        // Transition after 0.8s
        currentTask?.cancel()
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8s
            if !Task.isCancelled {
                await MainActor.run {
                    shakeOffset = 0
                    transitionTo(.containerToAnswer)
                }
            }
        }
    }

    private func startAnswerDelay() {
        currentTask?.cancel()
        currentTask = Task {
            // Call fortune API
            await viewModel.draw()

            // Cache fortune level
            if case .loaded(let fortune) = viewModel.state {
                await MainActor.run {
                    selectedFortuneLevel = fortune.level.key
                }
            }

            // Wait 0.5s then proceed
            try? await Task.sleep(nanoseconds: 500_000_000)

            if !Task.isCancelled {
                transitionTo(.categoryReveal)
            }
        }
    }

    private func startCategoryDelay() {
        currentTask?.cancel()
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.0s
            if !Task.isCancelled {
                transitionTo(.intermediateResult)
            }
        }
    }

    private func startIntermediateDelay() {
        currentTask?.cancel()
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.0s
            if !Task.isCancelled {
                transitionTo(.daruma1)
            }
        }
    }

    private func startDaruma1Delay() {
        currentTask?.cancel()
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            if !Task.isCancelled {
                transitionTo(.darumaTransition)
            }
        }
    }

    private func startDaruma2Delay() {
        // Randomly select final result image
        selectedFinalIndex = Int.random(in: 0..<5)

        currentTask?.cancel()
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            if !Task.isCancelled {
                transitionTo(.finalResult)
            }
        }
    }

    private func showFinalResult() {
        // Play fortune-specific haptic
        if case .loaded(let fortune) = viewModel.state {
            let isSpecial = fortune.level.key == .ultra || fortune.level.key == .error
            HapticEngine.shared.playFortuneReveal(isSpecial: isSpecial)
        }

        // Entrance animation
        resultScale = 0.8
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            resultScale = 1.0
        }
    }

    private func resetFortune() {
        currentTask?.cancel()
        viewModel.reset()
        flowState = .idle
        selectedFortuneLevel = nil
        selectedFinalIndex = 0
        resultScale = 1.0
        shakeOffset = 0
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
