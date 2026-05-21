import XCTest
@testable import Melodify
import Combine

@MainActor
final class TrackDetailViewModelTest: XCTestCase {
    var sut: TrackDetailViewModel!
    var mockUseCase: MockGetTrackDetailUseCase!
    var cancellable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockGetTrackDetailUseCase()
        sut = TrackDetailViewModel(trackId: 1, getTrackDetailUseCase: mockUseCase)
        cancellable = []
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellable = nil
        super.tearDown()
    }

    func test_load_success_populatesDetail() async {
        mockUseCase.stubbedResult = .success(
            Track(id: 1, title: "Title", artist: "Artist", album: "Album",
                  artworkURL: nil, previewURL: nil, genre: "Genre", durationMs: 300)
        )

        let expectation = expectation(description: "detail published")
        sut.$detail
            .dropFirst()
            .compactMap { $0 }
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellable)

        sut.load()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(sut.detail?.title, "Title")
    }

    func test_load_failure_setsErrorMessage() async {
        mockUseCase.stubbedResult = .failure(APIError.networkError(URLError(.notConnectedToInternet)))

        let expectation = expectation(description: "error published")
        sut.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellable)

        sut.load()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertNotNil(sut.errorMessage)
    }
}
