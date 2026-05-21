import XCTest
@testable import Melodify

@MainActor
final class FetchHomeSectionsUseCaseTests: XCTestCase {
    var sut: FetchHomeSectionsUseCase!
    var mockRepository: MockTrackRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockTrackRepository()
        sut = FetchHomeSectionsUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_execute_success_returnsOneSectionPerGenre() async throws {
        mockRepository.stubbedResult = .success([.stub()])

        let genreQueries: [(genre: String, query: SearchTracksQuery)] = [
            ("Rock", SearchTracksQuery(term: "rock")),
            ("Pop", SearchTracksQuery(term: "pop"))
        ]
        let param = FetchHomeSectionsParam(query: FetchHomeSectionsQuery(genreQueries: genreQueries))
        let sections = try await sut.execute(policy: .fresh, param: param)

        XCTAssertEqual(sections.count, 2)
    }

    func test_execute_preservesInputGenreOrder() async throws {
        mockRepository.searchHandler = { _, param in
            [Track.stub(genre: param.query.term.capitalized)]
        }

        let genreQueries: [(genre: String, query: SearchTracksQuery)] = [
            ("Rock", SearchTracksQuery(term: "rock")),
            ("Pop", SearchTracksQuery(term: "pop")),
            ("Jazz", SearchTracksQuery(term: "jazz"))
        ]
        let param = FetchHomeSectionsParam(query: FetchHomeSectionsQuery(genreQueries: genreQueries))
        let sections = try await sut.execute(policy: .fresh, param: param)

        XCTAssertEqual(sections.map { $0.genre }, ["Rock", "Pop", "Jazz"])
    }

    func test_execute_repositoryThrows_propagatesError() async {
        mockRepository.stubbedResult = .failure(APIError.networkError(URLError(.notConnectedToInternet)))

        let genreQueries: [(genre: String, query: SearchTracksQuery)] = [("Rock", SearchTracksQuery(term: "rock"))]
        let param = FetchHomeSectionsParam(query: FetchHomeSectionsQuery(genreQueries: genreQueries))
        do {
            _ = try await sut.execute(policy: .fresh, param: param)
            XCTFail("Expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func test_execute_emptyGenres_returnsEmptyArray() async throws {
        let param = FetchHomeSectionsParam(query: FetchHomeSectionsQuery(genreQueries: []))
        let sections = try await sut.execute(policy: .fresh, param: param)
        XCTAssertTrue(sections.isEmpty)
    }
}
