import XCTest
@testable import Melodify

final class TrackUIModelMapperTests: XCTestCase {

    func test_toUIModel_mapsIdTitleArtistArtworkURL() {
        let track = Track.stub(id: 7, title: "Yellow", artist: "Coldplay")

        let uiModel = TrackUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.id, 7)
        XCTAssertEqual(uiModel.title, "Yellow")
        XCTAssertEqual(uiModel.artist, "Coldplay")
        XCTAssertNil(uiModel.artworkURL)
    }

    func test_toUIModel_formatsDurationAsMinutesAndSeconds() {
        let track = Track.stub(durationMs: 210000) // 3:30

        let uiModel = TrackUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.duration, "3:30")
    }

    func test_toUIModel_durationPadsSecondsBelowTen() {
        let track = Track.stub(durationMs: 189000) // 3:09

        let uiModel = TrackUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.duration, "3:09")
    }

    func test_toUIModel_durationZeroSeconds() {
        let track = Track.stub(durationMs: 180000) // 3:00

        let uiModel = TrackUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.duration, "3:00")
    }

    func test_toUIModel_artworkURLMappedWhenPresent() {
        let url = URL(string: "https://example.com/art.jpg")!
        let track = Track(id: 1, title: "T", artist: "A", album: "B", artworkURL: url, previewURL: nil, genre: "Pop", durationMs: 0)

        let uiModel = TrackUIModelMapper.toUIModel(track)

        XCTAssertEqual(uiModel.artworkURL, url)
    }
}
