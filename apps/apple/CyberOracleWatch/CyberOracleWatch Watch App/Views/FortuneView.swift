import SwiftUI

/// Fortune Sticks screen - electronic divination
/// Will be fully implemented in Sprint 4
struct FortuneView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("FORTUNE STICKS")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(cyan)

                Text("⚡")
                    .font(.system(size: 48))

                Text("Shake for fortune")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.gray)

                Text("Coming in Sprint 4")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
    }

    private var cyan: Color {
        Color(red: 0/255, green: 255/255, blue: 255/255)
    }
}

#Preview {
    FortuneView()
}
