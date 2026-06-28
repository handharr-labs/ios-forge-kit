import Foundation
import Core

struct GetTrackDetailPath: Sendable {
    let id: Int
}

typealias GetTrackDetailRequest = Request<Void, GetTrackDetailPath>
