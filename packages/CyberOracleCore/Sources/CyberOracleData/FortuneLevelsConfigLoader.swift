import Foundation
import CyberOracleDomain

public enum FortuneLevelsConfigLoaderError: Error, Equatable {
    case resourceNotFound(String)
    case decodingFailed
    case invalidProbabilities
}

public struct FortuneLevelsConfigLoader: Sendable {
    public init() {}

    public func loadBundledConfig(resourceName: String = "fortune_levels", resourceExtension: String = "json") throws -> FortuneLevelsConfig {
        guard let url = Bundle.module.url(forResource: resourceName, withExtension: resourceExtension) else {
            throw FortuneLevelsConfigLoaderError.resourceNotFound("\(resourceName).\(resourceExtension)")
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let config: FortuneLevelsConfig
        do {
            config = try decoder.decode(FortuneLevelsConfig.self, from: data)
        } catch {
            throw FortuneLevelsConfigLoaderError.decodingFailed
        }

        let sum = config.levels.map(\.probability).reduce(0.0, +)
        if abs(sum - 1.0) > 0.0001 {
            throw FortuneLevelsConfigLoaderError.invalidProbabilities
        }
        return config
    }
}

