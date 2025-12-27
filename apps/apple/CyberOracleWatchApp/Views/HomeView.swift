import SwiftUI

/// Home screen - Cyberpunk time HUD
/// Displays current date and time in PRD-specified format
struct HomeView: View {
    @State private var currentTime = Date()

    // Timer to update time every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Background (placeholder - will add cyberpunk effects in Sprint 5)
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 8) {
                // Year/Month (top)
                yearMonthText
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .foregroundColor(neonGreen)

                // Date
                dateText
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(cyan)

                Spacer()
                    .frame(height: 20)

                // Time (HH:mm:ss)
                timeText
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(neonGreen)

                Spacer()

                // Navigation hint
                Text("← Swipe →")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(neonGreen.opacity(0.5))
            }
            .padding()
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    // MARK: - Date/Time Formatters

    private var yearMonthText: Text {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        return Text(formatter.string(from: currentTime))
    }

    private var dateText: Text {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return Text("/ date \(formatter.string(from: currentTime))")
    }

    private var timeText: Text {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return Text(formatter.string(from: currentTime))
    }

    // MARK: - Colors (placeholder - will move to CyberTheme in Sprint 5)

    private var neonGreen: Color {
        Color(red: 0/255, green: 255/255, blue: 65/255) // #00FF41
    }

    private var cyan: Color {
        Color(red: 0/255, green: 255/255, blue: 255/255) // #00FFFF
    }
}

#Preview {
    HomeView()
}
