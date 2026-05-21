import XCTest
@testable import Melodify

@MainActor
final class UpdatePlaylistUseCaseTests: XCTestCase {
    var sut: UpdatePlaylistUseCase!
    var mockRepository: MockPlaylistRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockPlaylistRepository()
        sut = UpdatePlaylistUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_execute_emptyName_throwsEmptyNameError() async {
        let param = UpdatePlaylistParam(query: UpdatePlaylistQuery(name: "", description: "desc"), path: UpdatePlaylistPath(id: 1))
        do {
            _ = try await sut.execute(param: param)
            XCTFail("Expected PlaylistError.emptyName")
        } catch PlaylistError.emptyName {
            XCTAssertNil(mockRepository.lastUpdateParam)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_execute_whitespaceName_throwsEmptyNameError() async {
        let param = UpdatePlaylistParam(query: UpdatePlaylistQuery(name: "  ", description: "desc"), path: UpdatePlaylistPath(id: 1))
        do {
            _ = try await sut.execute(param: param)
            XCTFail("Expected PlaylistError.emptyName")
        } catch PlaylistError.emptyName {
            XCTAssertNil(mockRepository.lastUpdateParam)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_execute_validName_callsRepositoryWithCorrectParam() async throws {
        let expected = Playlist.stub(id: 7, name: "Updated")
        mockRepository.updateResult = .success(expected)
        let param = UpdatePlaylistParam(query: UpdatePlaylistQuery(name: "Updated", description: "new desc"), path: UpdatePlaylistPath(id: 7))

        let result = try await sut.execute(param: param)

        XCTAssertEqual(result.id, 7)
        XCTAssertEqual(mockRepository.lastUpdateParam?.query.name, "Updated")
        XCTAssertEqual(mockRepository.lastUpdateParam?.path.id, 7)
    }

    func test_execute_repositoryThrows_propagatesError() async {
        mockRepository.updateResult = .failure(APIError.networkError(URLError(.notConnectedToInternet)))
        let param = UpdatePlaylistParam(query: UpdatePlaylistQuery(name: "Updated", description: ""), path: UpdatePlaylistPath(id: 1))
        do {
            _ = try await sut.execute(param: param)
            XCTFail("Expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
