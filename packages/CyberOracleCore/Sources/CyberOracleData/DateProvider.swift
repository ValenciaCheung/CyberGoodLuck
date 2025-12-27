import Foundation

public protocol DateProviding: Sendable {
    func now() -> Date
}

public struct SystemDateProvider: DateProviding {
    public init() {}

    public func now() -> Date {
        Date()
    }
}

