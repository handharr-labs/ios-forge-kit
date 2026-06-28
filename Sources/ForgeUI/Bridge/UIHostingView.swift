import SwiftUI
import UIKit

/// **SwiftUI → UIKit** bridge for **inline** hosting: a `UIView` subclass that hosts a
/// SwiftUI view inline — no child view controller needed. Use this to embed SwiftUI
/// components (e.g. `FUIAvatar`, `FUILoadingOverlay`) inside a UIKit layout (a cell, a
/// header, a toolbar slot) without the lifecycle overhead of `UIHostingController`.
/// To host a SwiftUI view as a *whole screen* (push/present), use `FUIHostingController`.
///
/// Note: SwiftUI appearance callbacks (onAppear/onDisappear) fire correctly because
/// the host view participates in the UIKit view hierarchy, not the VC hierarchy.
public final class UIHostingView<Content: View>: UIView {
    private let host: UIHostingController<Content>

    public init(rootView: Content) {
        host = UIHostingController(rootView: rootView)
        super.init(frame: .zero)
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: topAnchor),
            host.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func update(rootView: Content) {
        host.rootView = rootView
    }
}
