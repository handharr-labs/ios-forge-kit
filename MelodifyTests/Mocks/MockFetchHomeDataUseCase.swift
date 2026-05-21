import Foundation
@testable import Melodify

final class MockFetchHomeDataUseCase: FetchHomeDataUseCaseProtocol {
    var stubbedResult: Result<HomeData, Error> = .success(HomeData(featuredTracks: [], playlists: []))
    private(set) var executeCallCount = 0

    func execute(policy: FetchPolicy, param: FetchHomeDataParam) async throws -> HomeData {
        executeCallCount += 1
        return try stubbedResult.get()
    }
}
