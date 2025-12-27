import Foundation
import CyberOracleDomain

public struct SplitMix64: RandomNumberGenerator, Sendable {
    private var state: UInt64

    public init(seed: UInt64) {
        self.state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }

    public mutating func nextUnitInterval() -> Double {
        let upper53 = next() >> 11
        return Double(upper53) / Double(1 << 53)
    }
}

public struct OracleSeed: Hashable, Sendable {
    public let value: UInt64
    public init(_ value: UInt64) { self.value = value }
}

public struct OracleDeterminism: Sendable {
    public init() {}

    public func daySeed(for date: Date, calendar: Calendar = .autoupdatingCurrent) -> OracleSeed {
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        let y = UInt64(comps.year ?? 0)
        let m = UInt64(comps.month ?? 0)
        let d = UInt64(comps.day ?? 0)
        return OracleSeed(y &* 10_000 &+ m &* 100 &+ d)
    }

    public func hashSeed(_ string: String) -> OracleSeed {
        var hasher = Hasher()
        hasher.combine(string)
        let hashed = UInt64(bitPattern: Int64(hasher.finalize()))
        return OracleSeed(hashed)
    }

    public func combine(_ a: OracleSeed, _ b: OracleSeed) -> OracleSeed {
        OracleSeed(a.value &* 6364136223846793005 &+ b.value &+ 0x9E3779B97F4A7C15)
    }
}

public struct DailyLuckGenerator: Sendable {
    public init() {}

    public func generate(for date: Date, seed: OracleSeed, calendar: Calendar = .autoupdatingCurrent) -> DailyLuck {
        let dayStart = calendar.startOfDay(for: date)
        var rng = SplitMix64(seed: seed.value)

        var metrics: [DailyLuckMetric: DailyLuckTier] = [:]
        for metric in DailyLuckMetric.allCases {
            let tier = sampleTier(&rng)
            metrics[metric] = tier
        }
        return DailyLuck(date: dayStart, metrics: metrics)
    }

    private func sampleTier(_ rng: inout SplitMix64) -> DailyLuckTier {
        let u = approximateNormal01(&rng)

        if u >= 1.15 { return .great }
        if u >= 0.05 { return .good }
        if u >= -1.15 { return .ok }
        return .bad
    }

    private func approximateNormal01(_ rng: inout SplitMix64) -> Double {
        var sum = 0.0
        for _ in 0..<12 {
            sum += rng.nextUnitInterval()
        }
        return sum - 6.0
    }
}

public struct FortuneDrawer: Sendable {
    public init() {}

    public func draw(at date: Date, levels: [FortuneLevel], seed: OracleSeed) -> FortuneDraw {
        var rng = SplitMix64(seed: seed.value)
        let picked = pickLevel(levels: levels, rng: &rng)
        let copy = pickCopy(level: picked, rng: &rng)
        return FortuneDraw(drawnAt: date, level: picked, copy: copy)
    }

    private func pickLevel(levels: [FortuneLevel], rng: inout SplitMix64) -> FortuneLevel {
        let roll = rng.nextUnitInterval()
        var cumulative = 0.0
        for level in levels {
            cumulative += level.probability
            if roll <= cumulative {
                return level
            }
        }
        return levels.last ?? FortuneLevel(
            key: .basic,
            label: "小吉",
            emoji: "🔵",
            probability: 1.0,
            color: "#00A0FF",
            style: "calm_blue",
            copyExamples: ["平稳运行，无功无过。"],
            haptics: "neutral",
            humorize: nil
        )
    }

    private func pickCopy(level: FortuneLevel, rng: inout SplitMix64) -> String {
        guard !level.copyExamples.isEmpty else { return "" }
        let idx = Int(floor(rng.nextUnitInterval() * Double(level.copyExamples.count)))
        return level.copyExamples[min(max(idx, 0), level.copyExamples.count - 1)]
    }
}

