import SwiftUI
import Combine
import AVKit
import AVFoundation

/// Helper class for managing video playback on watchOS
/// Provides AVPlayer wrapper with completion handling for animation videos
@MainActor
class VideoPlayerHelper: ObservableObject {
    @Published var player: AVPlayer?
    private var observer: NSObjectProtocol?

    /// Callback when video completes playing
    var onVideoComplete: (() -> Void)?

    /// Setup video player with a specific video file from bundle
    /// - Parameters:
    ///   - videoName: Name of video file without extension
    ///   - fileExtension: File extension (default: "mp4")
    ///   - completion: Callback when video finishes playing
    func setupPlayer(videoName: String, fileExtension: String = "mp4", completion: @escaping () -> Void) {
        // Store completion callback
        onVideoComplete = completion

        // Get video URL from bundle
        guard let videoURL = Bundle.main.url(forResource: videoName, withExtension: fileExtension) else {
            print("❌ VideoPlayerHelper: Cannot find video file: \(videoName).\(fileExtension)")
            return
        }

        // Create player
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)

        // Observe when video finishes
        observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            print("✅ VideoPlayerHelper: Video playback completed")
            self?.onVideoComplete?()
        }

        print("✅ VideoPlayerHelper: Player setup complete for \(videoName)")
    }

    /// Play the video
    func play() {
        guard let player = player else {
            print("⚠️ VideoPlayerHelper: Cannot play - player not setup")
            return
        }

        // Seek to beginning if video has already played
        player.seek(to: .zero)
        player.play()
        print("▶️ VideoPlayerHelper: Playing video")
    }

    /// Pause the video
    func pause() {
        player?.pause()
        print("⏸️ VideoPlayerHelper: Video paused")
    }

    /// Stop and reset the video
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
        print("⏹️ VideoPlayerHelper: Video stopped")
    }

    /// Cleanup resources
    func cleanup() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        player?.pause()
        player = nil
        print("🧹 VideoPlayerHelper: Cleaned up")
    }

    nonisolated deinit {
        // Can't call cleanup() here due to MainActor isolation
        // Cleanup will be called manually via onDisappear
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
