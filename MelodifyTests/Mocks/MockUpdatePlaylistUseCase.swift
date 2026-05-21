import Foundation
@testable import Melodify

final class MockUpdatePlaylistUseCase: UpdatePlaylistUseCaseProtocol {
    var stubbedResult: Result<Playlist, Error> = .success(.stub())
    private(set) var lastParam: UpdatePlaylistParam?

    func execute(param: UpdatePlaylistParam) async throws -> Playlist {
        lastParam = param
        return try stubbedResult.get()
    }
}
