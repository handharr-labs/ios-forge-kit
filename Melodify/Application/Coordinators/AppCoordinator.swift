import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private var childCoordinators: [AnyObject] = []

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let client = APIClient()
        let trackRepository = TrackRepository(remoteDataSource: TrackRemoteDataSource(client: client))
        let playlistRepository = PlaylistRepository(remoteDataSource: PlaylistRemoteDataSource(client: client))

        let search = SearchCoordinator(trackRepository: trackRepository)
        let home = HomeCoordinator(trackRepository: trackRepository, playlistRepository: playlistRepository)
        childCoordinators = [search, home]

        search.start()
        home.start()

        let tabBar = UITabBarController()
        tabBar.viewControllers = [search.navigationController, home.navigationController]
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}
