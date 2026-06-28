import Foundation
import Core

struct FetchConversationsQuery: Sendable, Equatable {
    let userId: String
}

typealias FetchConversationsRequest = Request<FetchConversationsQuery, Void>
