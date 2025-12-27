import Foundation

public enum FortuneLevelKey: String, Codable, CaseIterable, Sendable {
    case ultra = "ULTRA"
    case superLevel = "SUPER"
    case basic = "BASIC"
    case glitch = "GLITCH"
    case error = "ERROR"
}

public struct FortuneLevel: Codable, Equatable, Sendable {
    public let key: FortuneLevelKey
    public let label: String
    public let emoji: String
    public let probability: Double
    public let color: String
    public let style: String
    public let copyExamples: [String]
    public let haptics: String
    public let humorize: Bool?

    public init(
        key: FortuneLevelKey,
        label: String,
        emoji: String,
        probability: Double,
        color: String,
        style: String,
        copyExamples: [String],
        haptics: String,
        humorize: Bool?
    ) {
        self.key = key
        self.label = label
        self.emoji = emoji
        self.probability = probability
        self.color = color
        self.style = style
        self.copyExamples = copyExamples
        self.haptics = haptics
        self.humorize = humorize
    }

    enum CodingKeys: String, CodingKey {
        case key
        case label
        case emoji
        case probability
        case color
        case style
        case copyExamples = "copy_examples"
        case haptics
        case humorize
    }
}

public struct FortuneThemeWatchFace: Codable, Equatable, Sendable {
    public let background: String
    public let timePrimary: String
    public let dateHighlight: String

    public init(background: String, timePrimary: String, dateHighlight: String) {
        self.background = background
        self.timePrimary = timePrimary
        self.dateHighlight = dateHighlight
    }

    enum CodingKeys: String, CodingKey {
        case background
        case timePrimary = "time_primary"
        case dateHighlight = "date_highlight"
    }
}

public struct FortuneThemes: Codable, Equatable, Sendable {
    public let primary: [String]
    public let watchFace: FortuneThemeWatchFace

    public init(primary: [String], watchFace: FortuneThemeWatchFace) {
        self.primary = primary
        self.watchFace = watchFace
    }

    enum CodingKeys: String, CodingKey {
        case primary
        case watchFace = "watch_face"
    }
}

public struct FortuneLevelsConfig: Codable, Equatable, Sendable {
    public let version: String
    public let locale: String
    public let levels: [FortuneLevel]
    public let distributionNote: String?
    public let themes: FortuneThemes?

    public init(
        version: String,
        locale: String,
        levels: [FortuneLevel],
        distributionNote: String?,
        themes: FortuneThemes?
    ) {
        self.version = version
        self.locale = locale
        self.levels = levels
        self.distributionNote = distributionNote
        self.themes = themes
    }

    enum CodingKeys: String, CodingKey {
        case version
        case locale
        case levels
        case distributionNote = "distribution_note"
        case themes
    }
}

public struct FortuneDraw: Codable, Equatable, Sendable {
    public let drawnAt: Date
    public let level: FortuneLevel
    public let copy: String

    public init(drawnAt: Date, level: FortuneLevel, copy: String) {
        self.drawnAt = drawnAt
        self.level = level
        self.copy = copy
    }
}

