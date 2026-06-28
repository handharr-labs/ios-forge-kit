import Foundation
import Core

struct FetchStoriesQuery: Sendable, Equatable {
    let cursor: Int?
}

typealias FetchStoriesRequest = Request<FetchStoriesQuery, Void>
