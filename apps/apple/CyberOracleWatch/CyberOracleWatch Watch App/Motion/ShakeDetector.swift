import Foundation
import CoreMotion
import Combine

/// Detects shake gestures using device accelerometer
/// Monitors acceleration magnitude to trigger shake events
@MainActor
public final class ShakeDetector: ObservableObject {
    @Published public private(set) var isShaking = false
    @Published public private(set) var shakeIntensity: Double = 0.0

    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private let threshold: Double
    private let minimumDuration: TimeInterval

    private var shakeStartTime: Date?

    /// Initialize shake detector
    /// - Parameters:
    ///   - threshold: Acceleration magnitude threshold (g-force, default 2.5)
    ///   - minimumDuration: Minimum shake duration to trigger (default 0.3 seconds)
    public init(threshold: Double = 2.5, minimumDuration: TimeInterval = 0.3) {
        self.threshold = threshold
        self.minimumDuration = minimumDuration
    }

    /// Start monitoring for shake gestures
    public func startDetecting() {
        guard motionManager.isAccelerometerAvailable else {
            print("⚠️ Accelerometer not available")
            return
        }

        motionManager.accelerometerUpdateInterval = 0.1 // 10 Hz
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let self = self, let data = data else { return }

            Task { @MainActor in
                self.processAcceleration(data.acceleration)
            }
        }
    }

    /// Stop monitoring
    public func stopDetecting() {
        motionManager.stopAccelerometerUpdates()
        Task { @MainActor in
            self.isShaking = false
            self.shakeIntensity = 0.0
            self.shakeStartTime = nil
        }
    }

    private func processAcceleration(_ acceleration: CMAcceleration) {
        // Calculate total acceleration magnitude (removing gravity baseline)
        let magnitude = sqrt(
            pow(acceleration.x, 2) +
            pow(acceleration.y, 2) +
            pow(acceleration.z, 2)
        ) - 1.0 // Subtract gravity (1g)

        shakeIntensity = max(0, magnitude)

        if magnitude > threshold {
            // Shake detected
            if shakeStartTime == nil {
                shakeStartTime = Date()
            }

            // Check if shake duration exceeds minimum
            if let startTime = shakeStartTime,
               Date().timeIntervalSince(startTime) >= minimumDuration {
                isShaking = true
            }
        } else {
            // No shake detected
            shakeStartTime = nil
            isShaking = false
        }
    }

    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}
