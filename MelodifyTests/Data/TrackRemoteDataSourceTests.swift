import XCTest
@testable import Melodify

@MainActor
final class TrackRemoteDataSourceTests: XCTestCase {
    var sut: TrackRemoteDataSource!
    var mockClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockClient = MockAPIClient()
        sut = TrackRemoteDataSource(client: mockClient)
    }

    override func tearDown() {
        sut = nil
        mockClient = nil
        super.tearDown()
    }

    func test_searchTracks_buildsCorrectBaseURLAndPath() async throws {
        mockClient.getStub = iTunesSearchResponse(results: [])
        let request = TrackSearchRequest(query: "coldplay", offset: 0, limit: 20)

        _ = try await sut.searchTracks(request)

        let url = try XCTUnwrap(mockClient.lastGetURL)
        XCTAssertEqual(url.host, "itunes.apple.com")
        XCTAssertEqual(url.path, "/search")
    }

    func test_searchTracks_includesQueryParamsInURL() async throws {
        mockClient.getStub = iTunesSearchResponse(results: [])
        let request = TrackSearchRequest(query: "coldplay", offset: 40, limit: 20)

        _ = try await sut.searchTracks(request)

        let url = try XCTUnwrap(mockClient.lastGetURL)
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "term", value: "coldplay")))
        XCTAssertTrue(items.contains(URLQueryItem(name: "limit", value: "20")))
        XCTAssertTrue(items.contains(URLQueryItem(name: "offset", value: "40")))
        XCTAssertTrue(items.contains(URLQueryItem(name: "media", value: "music")))
    }

    func test_getTrackDetail_buildsCorrectURL() async throws {
        mockClient.getStub = iTunesSearchResponse(results: [TrackDTO.stub(trackId: 123)])
        let request = TrackDetailRequest(id: 123)

        _ = try await sut.getTrackDetail(request)

        let url = try XCTUnwrap(mockClient.lastGetURL)
        XCTAssertEqual(url.path, "/lookup")
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "id", value: "123")))
    }

    func test_getTrackDetail_emptyResults_throwsNotFound() async {
        mockClient.getStub = iTunesSearchResponse(results: [])
        let request = TrackDetailRequest(id: 1)

        do {
            _ = try await sut.getTrackDetail(request)
            XCTFail("Expected APIError.notFound")
        } catch APIError.notFound {
            // pass
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_searchTracks_clientThrows_propagatesError() async {
        mockClient.shouldThrow = APIError.networkError(URLError(.notConnectedToInternet))
        let request = TrackSearchRequest(query: "test", offset: 0, limit: 20)

        do {
            _ = try await sut.searchTracks(request)
            XCTFail("Expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
