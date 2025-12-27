import SwiftUI

/// Daily Luck screen - displays 4 luck metrics
/// Will be fully implemented in Sprint 2
struct DailyLuckView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("DAILY LUCK")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(neonGreen)

                Text("💗 💰 💼 ❤️‍🩹")
                    .font(.system(size: 32))

                Text("Coming in Sprint 2")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
    }

    private var neonGreen: Color {
        Color(red: 0/255, green: 255/255, blue: 65/255)
    }
}

#Preview {
    DailyLuckView()
}
