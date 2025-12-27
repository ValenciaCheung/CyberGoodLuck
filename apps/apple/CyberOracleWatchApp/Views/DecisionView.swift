import SwiftUI

/// Decision Maker screen - Yes/No coin flip
/// Will be fully implemented in Sprint 3
struct DecisionView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("DECISION MAKER")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(magenta)

                Text("🙏")
                    .font(.system(size: 48))

                Text("Shake it")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.gray)

                Text("Coming in Sprint 3")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
    }

    private var magenta: Color {
        Color(red: 255/255, green: 0/255, blue: 255/255)
    }
}

#Preview {
    DecisionView()
}
