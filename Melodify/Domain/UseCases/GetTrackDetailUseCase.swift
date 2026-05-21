//
//  GetTrackDetailUseCase.swift
//  Melodify
//
//  Created by puras.handharmahua@mekari.com on 21/05/26.
//

import Foundation

protocol GetTrackDetailUseCaseProtocol {
    func execute(policy: FetchPolicy, param: GetTrackDetailParam) async throws -> Track
}

final class GetTrackDetailUseCase: GetTrackDetailUseCaseProtocol {
    private let repository: TrackRepositoryProtocol

    init(repository: TrackRepositoryProtocol) {
        self.repository = repository
    }

    func execute(policy: FetchPolicy, param: GetTrackDetailParam) async throws -> Track {
        return try await repository.getTrackDetail(policy: policy, param: param)
    }
}
