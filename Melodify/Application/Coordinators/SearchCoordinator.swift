import UIKit

protocol TrackListDelegate: AnyObject {
    func didSelectTrack(id: Int)
}

final class SearchCoordinator: Coordinator {
    let navigationController = UINavigationController()
    private let trackRepository: TrackRepositoryProtocol

    init(trackRepository: TrackRepositoryProtocol) {
        self.trackRepository = trackRepository
    }

    func start() {
        let viewModel = TrackListViewModel(searchTracks: SearchTracksUseCase(repository: trackRepository))
        let vc = TrackListViewController(viewModel: viewModel)
        vc.delegate = self
        vc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        navigationController.viewControllers = [vc]
    }
}

extension SearchCoordinator: TrackListDelegate {
    func didSelectTrack(id: Int) {
        let useCase = GetTrackDetailUseCase(repository: trackRepository)
        let viewModel = TrackDetailViewModel(trackId: id, getTrackDetailUseCase: useCase)
        let vc = TrackDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
