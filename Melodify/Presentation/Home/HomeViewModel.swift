import Foundation

@MainActor
final class HomeViewModel {
    private let fetchHomeData: FetchHomeDataUseCaseProtocol

    private(set) var featuredTracks: [TrackUIModel] = []
    private(set) var playlists: [PlaylistUIModel] = []
    private(set) var isLoading: Bool = false

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    init(fetchHomeData: FetchHomeDataUseCaseProtocol) {
        self.fetchHomeData = fetchHomeData
    }

    func loadHome() {
        guard !isLoading else { return }
        isLoading = true

        let param = FetchHomeDataParam(
            query: FetchHomeDataQuery(
                trackQuery: SearchTracksQuery(term: "top hits", page: 1, limit: 20)
            )
        )

        Task {
            defer { isLoading = false }
            do {
                let data = try await fetchHomeData.execute(policy: .cached, param: param)
                featuredTracks = data.featuredTracks.map(TrackUIModelMapper.toUIModel)
                playlists = data.playlists.map(PlaylistUIModelMapper.toUIModel)
                onUpdate?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
