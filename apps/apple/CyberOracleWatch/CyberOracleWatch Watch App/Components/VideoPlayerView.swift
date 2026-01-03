import SwiftUI
import AVFoundation
import AVKit

/// Reusable video player component for watchOS
/// Plays MP4 files from the app bundle with automatic completion detection
struct VideoPlayerView: View {
    let videoFileName: String
    let onComplete: () -> Void
    let fallbackImage: String?

    @State private var player: AVPlayer?
    @State private var isLoading = true
    @State private var hasFailed = false
    @State private var timeoutTask: Task<Void, Never>?

    init(videoFileName: String, onComplete: @escaping () -> Void, fallbackImage: String? = nil) {
        self.videoFileName = videoFileName
        self.onComplete = onComplete
        self.fallbackImage = fallbackImage
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if hasFailed, let fallback = fallbackImage {
                // Fallback to static image if video fails
                Image(fallback)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else if let player = player {
                // Video player - Full screen
                GeometryReader { geometry in
                    VideoPlayer(player: player)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .edgesIgnoringSafeArea(.all)
                }
                .ignoresSafeArea()
                .onAppear {
                    player.play()
                }
            } else if isLoading {
                // Loading state
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .onAppear {
            setupVideoPlayer()
            setupTimeout()
        }
        .onDisappear {
            cleanup()
        }
    }

    // MARK: - Setup

    private func setupVideoPlayer() {
        // Find video file in bundle
        guard let url = Bundle.main.url(forResource: videoFileName, withExtension: "mp4") else {
            print("⚠️ VideoPlayerView: File not found - \(videoFileName).mp4")
            hasFailed = true
            isLoading = false

            // Auto-advance after delay if no fallback image
            if fallbackImage == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
            return
        }

        // Create player
        let playerItem = AVPlayerItem(url: url)
        let avPlayer = AVPlayer(playerItem: playerItem)

        // Configure for seamless playback
        avPlayer.actionAtItemEnd = .none

        // Ensure video fills the screen by setting appropriate size
        avPlayer.automaticallyWaitsToMinimizeStalling = false

        self.player = avPlayer
        isLoading = false

        // Observe playback completion
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [onComplete] _ in
            print("✅ VideoPlayerView: Video completed - \(videoFileName)")
            onComplete()
        }

        // Observe playback errors
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [onComplete] notification in
            print("⚠️ VideoPlayerView: Playback failed - \(videoFileName)")
            if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
                print("Error: \(error.localizedDescription)")
            }
            onComplete() // Advance anyway to prevent getting stuck
        }

        print("🎬 VideoPlayerView: Setup complete - \(videoFileName)")
    }

    private func setupTimeout() {
        // Safety timeout: auto-advance after 10 seconds if video doesn't complete
        timeoutTask = Task {
            try? await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds

            // Check if still on this screen
            if player != nil && !Task.isCancelled {
                print("⏰ VideoPlayerView: Timeout reached - \(videoFileName)")
                await MainActor.run {
                    onComplete()
                }
            }
        }
    }

    // MARK: - Cleanup

    private func cleanup() {
        // Cancel timeout task
        timeoutTask?.cancel()
        timeoutTask = nil

        // Stop playback
        player?.pause()
        player = nil

        // Remove observers
        NotificationCenter.default.removeObserver(self)

        print("🧹 VideoPlayerView: Cleanup complete - \(videoFileName)")
    }
}

// MARK: - Preview

#Preview {
    VideoPlayerView(
        videoFileName: "fortune_shake_transition",
        onComplete: {
            print("Preview: Video completed")
        },
        fallbackImage: nil
    )
}
