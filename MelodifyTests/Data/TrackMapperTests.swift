import XCTest
@testable import Melodify

final class TrackMapperTests: XCTestCase {

    // MARK: - Happy path

    func test_toDomain_allFieldsPresent_mapsAllFieldsCorrectly() {
        let dto = TrackDTO(
            trackId: 42,
            trackName: "Yellow",
            artistName: "Coldplay",
            collectionName: "Parachutes",
            artworkUrl100: "https://example.com/art.jpg",
            previewUrl: "https://example.com/preview.mp3",
            primaryGenreName: "Rock",
            trackTimeMillis: 270000
        )

        let track = TrackMapper.toDomain(dto)

        XCTAssertNotNil(track)
        XCTAssertEqual(track?.id, 42)
        XCTAssertEqual(track?.title, "Yellow")
        XCTAssertEqual(track?.artist, "Coldplay")
        XCTAssertEqual(track?.album, "Parachutes")
        XCTAssertEqual(track?.genre, "Rock")
        XCTAssertEqual(track?.durationMs, 270000)
        XCTAssertEqual(track?.artworkURL, URL(string: "https://example.com/art.jpg"))
        XCTAssertEqual(track?.previewURL, URL(string: "https://example.com/preview.mp3"))
    }

    // MARK: - Guard conditions (required fields)

    func test_toDomain_nilTrackId_returnsNil() {
        let dto = TrackDTO.stub(trackId: nil)
        XCTAssertNil(TrackMapper.toDomain(dto))
    }

    func test_toDomain_nilTrackName_returnsNil() {
        let dto = TrackDTO.stub(trackName: nil)
        XCTAssertNil(TrackMapper.toDomain(dto))
    }

    func test_toDomain_nilArtistName_returnsNil() {
        let dto = TrackDTO.stub(artistName: nil)
        XCTAssertNil(TrackMapper.toDomain(dto))
    }

    // MARK: - Optional field defaults

    func test_toDomain_nilCollectionName_albumDefaultsToEmptyString() {
        let dto = TrackDTO.stub(collectionName: nil)
        XCTAssertEqual(TrackMapper.toDomain(dto)?.album, "")
    }

    func test_toDomain_nilGenre_genreDefaultsToEmptyString() {
        let dto = TrackDTO.stub(primaryGenreName: nil)
        XCTAssertEqual(TrackMapper.toDomain(dto)?.genre, "")
    }

    func test_toDomain_nilDuration_durationDefaultsToZero() {
        let dto = TrackDTO.stub(trackTimeMillis: nil)
        XCTAssertEqual(TrackMapper.toDomain(dto)?.durationMs, 0)
    }

    // MARK: - URL conversion

    func test_toDomain_nilArtworkURL_artworkURLIsNil() {
        let dto = TrackDTO(trackId: 1, trackName: "Title", artistName: "Artist", collectionName: nil, artworkUrl100: nil, previewUrl: nil, primaryGenreName: nil, trackTimeMillis: nil)
        XCTAssertNil(TrackMapper.toDomain(dto)?.artworkURL)
    }

    func test_toDomain_nilPreviewURL_previewURLIsNil() {
        let dto = TrackDTO(trackId: 1, trackName: "Title", artistName: "Artist", collectionName: nil, artworkUrl100: nil, previewUrl: nil, primaryGenreName: nil, trackTimeMillis: nil)
        XCTAssertNil(TrackMapper.toDomain(dto)?.previewURL)
    }
}
