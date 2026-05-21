import UIKit

final class HomeCoordinator: Coordinator {
    let navigationController = UINavigationController()
    private let trackRepository: TrackRepositoryProtocol
    private let playlistRepository: PlaylistRepositoryProtocol

    init(trackRepository: TrackRepositoryProtocol, playlistRepository: PlaylistRepositoryProtocol) {
        self.trackRepository = trackRepository
        self.playlistRepository = playlistRepository
    }

    func start() {
        let useCase = FetchHomeDataUseCase(trackRepository: trackRepository, playlistRepository: playlistRepository)
        let viewModel = HomeViewModel(fetchHomeData: useCase)
        let vc = HomeViewController(viewModel: viewModel)
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        navigationController.viewControllers = [vc]
    }
}
