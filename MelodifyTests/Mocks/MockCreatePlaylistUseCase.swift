import Foundation
@testable import Melodify

final class MockCreatePlaylistUseCase: CreatePlaylistUseCaseProtocol {
    var stubbedResult: Result<Playlist, Error> = .success(.stub())
    private(set) var lastParam: CreatePlaylistParam?

    func execute(param: CreatePlaylistParam) async throws -> Playlist {
        lastParam = param
        return try stubbedResult.get()
    }
}
