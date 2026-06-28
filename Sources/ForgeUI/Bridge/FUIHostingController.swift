import SwiftUI
import UIKit

/// **SwiftUI → UIKit** bridge for **screen-level** hosting: wraps a SwiftUI `View` in a
/// `UIViewController` you can push onto a `UINavigationController` or present modally
/// from a Coordinator.
///
/// Use this when the SwiftUI view *is* the screen. To embed a SwiftUI view inline
/// inside a larger UIKit layout (a cell, a header, a toolbar slot), use `UIHostingView`
/// instead — it needs no child view controller.
///
/// ```swift
/// let vc = FUIHostingController(rootView: SettingsScreen(viewModel: vm))
/// navigationController.pushViewController(vc, animated: true)
/// ```
public final class FUIHostingController<Content: View>: UIHostingController<Content> {
    public override init(rootView: Content) {
        super.init(rootView: rootView)
        view.backgroundColor = .clear
    }

    @available(*, unavailable)
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported — host a SwiftUI view via init(rootView:)")
    }
}
