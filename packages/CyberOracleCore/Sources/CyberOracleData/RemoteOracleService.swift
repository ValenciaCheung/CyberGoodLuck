import Foundation
import CyberOracleDomain

public enum RemoteOracleServiceError: Error, Equatable {
    case invalidURL
    case unexpectedStatusCode(Int)
    case decodingFailed
}

public final class RemoteOracleService: OracleService, @unchecked Sendable {
    private let baseURL: URL
    private let session: URLSession

    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func fortuneLevels() async throws -> FortuneLevelsConfig {
        try await get(path: "/v1/config/fortune-levels")
    }

    public func dailyLuck(for date: Date) async throws -> DailyLuck {
        let dateString = Self.isoDay(date)
        return try await get(path: "/v1/daily-luck?date=\(dateString)")
    }

    public func decideYesNo(question: String?, at date: Date) async throws -> DecisionResult {
        struct Body: Codable { let question: String?; let at: String }
        return try await post(path: "/v1/decision/yesno", body: Body(question: question, at: Self.isoInstant(date)))
    }

    public func drawFortune(at date: Date) async throws -> FortuneDraw {
        struct Body: Codable { let at: String }
        return try await post(path: "/v1/fortune/draw", body: Body(at: Self.isoInstant(date)))
    }

    private func get<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else { throw RemoteOracleServiceError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await execute(request: request)
    }

    private func post<T: Decodable, B: Encodable>(path: String, body: B) async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else { throw RemoteOracleServiceError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return try await execute(request: request)
    }

    private func execute<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw RemoteOracleServiceError.unexpectedStatusCode(-1) }
        guard (200..<300).contains(http.statusCode) else {
            throw RemoteOracleServiceError.unexpectedStatusCode(http.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RemoteOracleServiceError.decodingFailed
        }
    }

    private static func isoDay(_ date: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return f.string(from: date)
    }

    private static func isoInstant(_ date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }
}

