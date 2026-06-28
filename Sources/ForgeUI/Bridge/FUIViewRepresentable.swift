import SwiftUI
import UIKit

/// Generic **UIKit → SwiftUI** bridge: wrap *any* `UIView` so it can be used as a
/// SwiftUI `View`.
///
/// - `make` builds the view once — wire callbacks / one-time setup here.
/// - `update` re-applies state on every SwiftUI re-evaluation — call the component's
///   `configure(with:)` here.
///
/// Every ForgeUI UIKit component also ships a *named* wrapper built on this same
/// pattern (e.g. `FUITextFieldRepresentable`) that exposes its specific configuration
/// and callbacks. Prefer the named wrapper; reach for `FUIViewRepresentable` directly
/// only for an ad-hoc `UIView` that has no named bridge.
///
/// ```swift
/// FUIViewRepresentable(
///     make: { let v = FUITextField(); v.onTextChanged = { print($0) }; return v },
///     update: { $0.configure(with: config) }
/// )
/// ```
public struct FUIViewRepresentable<V: UIView>: UIViewRepresentable {
    private let make: () -> V
    private let update: (V) -> Void

    public init(make: @escaping () -> V, update: @escaping (V) -> Void = { _ in }) {
        self.make = make
        self.update = update
    }

    public func makeUIView(context: Context) -> V { make() }

    public func updateUIView(_ uiView: V, context: Context) { update(uiView) }
}
