import Foundation
@testable import Melodify

extension Playlist {
    static func stub(
        id: Int = 1,
        name: String = "Stub Playlist",
        description: String = "Stub Description",
        tracks: [Track] = []
    ) -> Playlist {
        Playlist(id: id, name: name, description: description, tracks: tracks)
    }
}
