import Foundation
import WatchKit

/// Haptic feedback engine for providing tactile responses
/// Uses WatchKit's haptic patterns for Decision and Fortune features
public final class HapticEngine {
    public static let shared = HapticEngine()

    private init() {}

    // MARK: - Decision Haptics

    /// Play haptic for coin toss (single light tap)
    public func playCoinFlip() {
        WKInterfaceDevice.current().play(.click)
    }

    /// Play success haptic for YES result
    public func playSuccess() {
        WKInterfaceDevice.current().play(.success)
    }

    /// Play failure haptic for NO result
    public func playFailure() {
        WKInterfaceDevice.current().play(.failure)
    }

    // MARK: - Daily Luck Haptics

    /// Play gentle haptic during Maneki-neko animation
    public func playCatShake() {
        WKInterfaceDevice.current().play(.click)
    }

    // MARK: - Fortune Stick Haptics

    /// Play stick collision haptic (light tap)
    public func playStickCollision() {
        WKInterfaceDevice.current().play(.click)
    }

    /// Play stick drop haptic (medium impact)
    public func playStickDrop() {
        WKInterfaceDevice.current().play(.notification)
    }

    /// Play fortune reveal haptic based on fortune level
    /// - Parameter isSpecial: True for ULTRA/ERROR levels
    public func playFortuneReveal(isSpecial: Bool) {
        if isSpecial {
            // Multiple taps for special fortunes
            WKInterfaceDevice.current().play(.notification)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                WKInterfaceDevice.current().play(.success)
            }
        } else {
            // Single tap for normal fortunes
            WKInterfaceDevice.current().play(.success)
        }
    }

    // MARK: - Generic Haptics

    /// Play gentle notification haptic
    public func playNotification() {
        WKInterfaceDevice.current().play(.notification)
    }

    /// Play start haptic (for beginning interactions)
    public func playStart() {
        WKInterfaceDevice.current().play(.start)
    }

    /// Play stop haptic (for ending interactions)
    public func playStop() {
        WKInterfaceDevice.current().play(.stop)
    }

    /// Play directional haptic (for navigation)
    public func playDirectionalUp() {
        WKInterfaceDevice.current().play(.directionUp)
    }

    /// Play directional haptic (for navigation)
    public func playDirectionalDown() {
        WKInterfaceDevice.current().play(.directionDown)
    }
}
