import Foundation
import Core

struct CreatePlaylistQuery: Sendable {
    let name: String
    let description: String
    let trackIds: [Int]
}

typealias CreatePlaylistRequest = Request<CreatePlaylistQuery, Void>
