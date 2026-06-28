import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUIPrimaryButton`. See `Bridge/README.md`.
///
/// `FUIPrimaryButton` is a `UIButton`, so its tap is wired through a `UIAction`
/// rather than a `configure(with:)` callback.
public struct FUIPrimaryButtonRepresentable: UIViewRepresentable {
    public let configuration: FUIPrimaryButtonConfiguration
    public let onTap: () -> Void

    public init(
        configuration: FUIPrimaryButtonConfiguration,
        onTap: @escaping () -> Void = {}
    ) {
        self.configuration = configuration
        self.onTap = onTap
    }

    public func makeUIView(context: Context) -> FUIPrimaryButton {
        let view = FUIPrimaryButton()
        let onTap = onTap
        view.addAction(UIAction { _ in onTap() }, for: .touchUpInside)
        return view
    }

    public func updateUIView(_ uiView: FUIPrimaryButton, context: Context) {
        uiView.configure(with: configuration)
    }
}
