import XCTest
import Combine
@testable import Melodify

@MainActor
final class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var mockUseCase: MockFetchHomeDataUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchHomeDataUseCase()
        sut = HomeViewModel(fetchHomeData: mockUseCase)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    func test_loadHome_success_populatesFeedItems() async {
        mockUseCase.stubbedResult = .success(HomeData(
            featuredTracks: [.stub(id: 1, title: "Yellow"), .stub(id: 2)],
            playlists: [.stub(id: 10, name: "Chill")]
        ))

        let expectation = expectation(description: "feedItems updated")
        sut.$feedItems
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.loadHome()
        await fulfillment(of: [expectation], timeout: 1)

        // 1 banner + 2 tracks + 1 playlist
        XCTAssertEqual(sut.feedItems.count, 4)
        guard case .banner(let banner) = sut.feedItems[0] else { return XCTFail("Expected banner at index 0") }
        XCTAssertEqual(banner.title, "Discover Music")
        guard case .track(let track) = sut.feedItems[1] else { return XCTFail("Expected track at index 1") }
        XCTAssertEqual(track.title, "Yellow")
        guard case .playlist(let playlist) = sut.feedItems[3] else { return XCTFail("Expected playlist at index 3") }
        XCTAssertEqual(playlist.name, "Chill")
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadHome_failure_setsErrorMessage() async {
        mockUseCase.stubbedResult = .failure(APIError.networkError(URLError(.notConnectedToInternet)))

        let expectation = expectation(description: "errorMessage updated")
        sut.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.loadHome()
        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertTrue(sut.feedItems.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadHome_doesNotFireWhileAlreadyLoading() async {
        mockUseCase.stubbedResult = .success(HomeData(featuredTracks: [], playlists: []))

        let expectation = expectation(description: "feedItems settled")
        sut.$feedItems
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.loadHome()
        sut.loadHome()
        sut.loadHome()

        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }
}
