import Foundation
@testable import Melodify

extension TrackDTO {
    static func stub(
        trackId: Int? = 1,
        trackName: String? = "Stub Track",
        artistName: String? = "Stub Artist",
        collectionName: String? = "Stub Album",
        primaryGenreName: String? = "Pop",
        trackTimeMillis: Int? = 210000
    ) -> TrackDTO {
        TrackDTO(
            trackId: trackId,
            trackName: trackName,
            artistName: artistName,
            collectionName: collectionName,
            artworkUrl100: nil,
            previewUrl: nil,
            primaryGenreName: primaryGenreName,
            trackTimeMillis: trackTimeMillis
        )
    }
}
