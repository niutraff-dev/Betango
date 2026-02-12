import Foundation

public struct EndpointPaths: Sendable, Equatable {
    public let objects: String
    public let statistics: String
    public let analytics: String

    public init(
        objects: String = "getComments",
        statistics: String = "getResults",
        analytics: String = "addComment"
    ) {
        self.objects = objects
        self.statistics = statistics
        self.analytics = analytics
    }
}

