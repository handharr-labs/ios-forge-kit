import XCTest
@testable import Melodify

@MainActor
final class PlaylistRemoteDataSourceTests: XCTestCase {
    var sut: PlaylistRemoteDataSource!
    var mockClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockClient = MockAPIClient()
        sut = PlaylistRemoteDataSource(client: mockClient)
    }

    override func tearDown() {
        sut = nil
        mockClient = nil
        super.tearDown()
    }

    func test_fetchPlaylists_callsCorrectURL() async throws {
        mockClient.getStub = [PlaylistDTO].stub()
        let request = FetchPlaylistsRequest()

        _ = try await sut.fetchPlaylists(request)

        let url = try XCTUnwrap(mockClient.lastGetURL)
        XCTAssertTrue(url.absoluteString.contains("/api/v1/playlist"))
    }

    func test_createPlaylist_callsCorrectURL() async throws {
        mockClient.postStub = PlaylistDTO.stub()
        let request = CreatePlaylistRequest(name: "My Mix", description: "desc", trackIds: [1, 2])

        _ = try await sut.createPlaylist(request)

        let url = try XCTUnwrap(mockClient.lastPostURL)
        XCTAssertTrue(url.absoluteString.contains("/api/v1/playlist"))
        XCTAssertFalse(url.absoluteString.hasSuffix("/1"))
    }

    func test_updatePlaylist_appendsIdToURL() async throws {
        mockClient.putStub = PlaylistDTO.stub()
        let request = UpdatePlaylistRequest(id: 7, name: "Updated", description: "desc")

        _ = try await sut.updatePlaylist(request)

        let url = try XCTUnwrap(mockClient.lastPutURL)
        XCTAssertTrue(url.absoluteString.hasSuffix("/7"))
    }

    func test_fetchPlaylists_clientThrows_propagatesError() async {
        mockClient.shouldThrow = APIError.networkError(URLError(.notConnectedToInternet))

        do {
            _ = try await sut.fetchPlaylists(FetchPlaylistsRequest())
            XCTFail("Expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
