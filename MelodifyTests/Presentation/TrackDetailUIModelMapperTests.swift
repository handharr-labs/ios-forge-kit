import XCTest
@testable import Melodify

final class TrackDetailUIModelMapperTests: XCTestCase {

    func test_toUIModel_mapsAllFields() {
        let url = URL(string: "https://example.com/art.jpg")!
        let track = Track(id: 1, title: "Yellow", artist: "Coldplay", album: "Parachutes", artworkURL: url, previewURL: nil, genre: "Rock", durationMs: 270000)

        let uiModel = TrackDetailUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.title, "Yellow")
        XCTAssertEqual(uiModel.artist, "Coldplay")
        XCTAssertEqual(uiModel.album, "Parachutes")
        XCTAssertEqual(uiModel.genre, "Rock")
        XCTAssertEqual(uiModel.artworkURL, url)
    }

    func test_toUIModel_formatsDurationAsMinutesAndSeconds() {
        let track = Track.stub(durationMs: 210000) // 3:30

        let uiModel = TrackDetailUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.duration, "3:30")
    }

    func test_toUIModel_durationPadsSecondsBelowTen() {
        let track = Track.stub(durationMs: 189000) // 3:09

        let uiModel = TrackDetailUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.duration, "3:09")
    }

    func test_toUIModel_durationZeroSeconds() {
        let track = Track.stub(durationMs: 180000) // 3:00

        let uiModel = TrackDetailUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.duration, "3:00")
    }
}
