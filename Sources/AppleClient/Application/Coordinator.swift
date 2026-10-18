// UINavigationController-based, so UIKit platforms only.
#if canImport(UIKit)
import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
#endif
