import XCTest
@testable import Melodify

@MainActor
final class CreatePlaylistUseCaseTests: XCTestCase {
    var sut: CreatePlaylistUseCase!
    var mockRepository: MockPlaylistRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockPlaylistRepository()
        sut = CreatePlaylistUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_execute_emptyName_throwsEmptyNameError() async {
        let param = CreatePlaylistParam(query: CreatePlaylistQuery(name: "", description: "desc", trackIds: []))
        do {
            _ = try await sut.execute(param: param)
            XCTFail("Expected PlaylistError.emptyName")
        } catch PlaylistError.emptyName {
            XCTAssertNil(mockRepository.lastCreateParam)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_execute_whitespaceName_throwsEmptyNameError() async {
        let param = CreatePlaylistParam(query: CreatePlaylistQuery(name: "   ", description: "desc", trackIds: []))
        do {
            _ = try await sut.execute(param: param)
            XCTFail("Expected PlaylistError.emptyName")
        } catch PlaylistError.emptyName {
            XCTAssertNil(mockRepository.lastCreateParam)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_execute_validName_callsRepositoryAndReturnsPlaylist() async throws {
        let expected = Playlist.stub(id: 42, name: "My Mix")
        mockRepository.createResult = .success(expected)
        let param = CreatePlaylistParam(query: CreatePlaylistQuery(name: "My Mix", description: "desc", trackIds: [1, 2]))

        let result = try await sut.execute(param: param)

        XCTAssertEqual(result.id, 42)
        XCTAssertEqual(mockRepository.lastCreateParam?.query.name, "My Mix")
        XCTAssertEqual(mockRepository.lastCreateParam?.query.trackIds, [1, 2])
    }

    func test_execute_repositoryThrows_propagatesError() async {
        mockRepository.createResult = .failure(APIError.networkError(URLError(.notConnectedToInternet)))
        let param = CreatePlaylistParam(query: CreatePlaylistQuery(name: "My Mix", description: "desc", trackIds: []))
        do {
            _ = try await sut.execute(param: param)
            XCTFail("Expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
