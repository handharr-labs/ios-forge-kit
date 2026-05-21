import XCTest
@testable import Melodify

@MainActor
final class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var mockUseCase: MockFetchHomeDataUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchHomeDataUseCase()
        sut = HomeViewModel(fetchHomeData: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_loadHome_success_populatesFeaturedTracksAndPlaylists() async {
        mockUseCase.stubbedResult = .success(HomeData(
            featuredTracks: [.stub(id: 1, title: "Yellow"), .stub(id: 2)],
            playlists: [.stub(id: 10, name: "Chill")]
        ))

        let expectation = expectation(description: "onUpdate called")
        sut.onUpdate = { expectation.fulfill() }

        sut.loadHome()
        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(sut.featuredTracks.count, 2)
        XCTAssertEqual(sut.featuredTracks.first?.title, "Yellow")
        XCTAssertEqual(sut.playlists.count, 1)
        XCTAssertEqual(sut.playlists.first?.name, "Chill")
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadHome_failure_callsOnError() async {
        mockUseCase.stubbedResult = .failure(APIError.networkError(URLError(.notConnectedToInternet)))

        let expectation = expectation(description: "onError called")
        sut.onError = { _ in expectation.fulfill() }

        sut.loadHome()
        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertTrue(sut.featuredTracks.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadHome_doesNotFireWhileAlreadyLoading() async {
        mockUseCase.stubbedResult = .success(HomeData(featuredTracks: [], playlists: []))

        let expectation = expectation(description: "settled")
        sut.onUpdate = { expectation.fulfill() }

        sut.loadHome()
        sut.loadHome()
        sut.loadHome()

        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }
}
