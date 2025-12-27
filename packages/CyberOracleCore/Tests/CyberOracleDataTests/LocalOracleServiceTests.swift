import XCTest
import CyberOracleData

final class LocalOracleServiceTests: XCTestCase {
    func test_fortuneLevels_loadsAndProbabilitiesSumToOne() async throws {
        let service = LocalOracleService()
        let config = try await service.fortuneLevels()
        XCTAssertFalse(config.levels.isEmpty)
        let sum = config.levels.map(\.probability).reduce(0.0, +)
        XCTAssertEqual(sum, 1.0, accuracy: 0.0001)
    }

    func test_dailyLuck_isDeterministicForSameDate() async throws {
        let service = LocalOracleService()
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        let a = try await service.dailyLuck(for: date)
        let b = try await service.dailyLuck(for: date)

        XCTAssertEqual(a, b)
    }

    func test_drawFortune_isDeterministicForSameDate() async throws {
        let service = LocalOracleService()
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        let a = try await service.drawFortune(at: date)
        let b = try await service.drawFortune(at: date)

        XCTAssertEqual(a.level.key, b.level.key)
        XCTAssertEqual(a.copy, b.copy)
    }
}

