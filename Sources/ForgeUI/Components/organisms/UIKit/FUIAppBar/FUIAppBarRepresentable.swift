import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUIAppBar`. See `Bridge/README.md`.
public struct FUIAppBarRepresentable: UIViewRepresentable {
    public let configuration: FUIAppBarConfiguration
    public var onBack: (() -> Void)?
    public var onTrailingTap: ((Int) -> Void)?
    public var onSearchTextChanged: ((String) -> Void)?

    public init(
        configuration: FUIAppBarConfiguration,
        onBack: (() -> Void)? = nil,
        onTrailingTap: ((Int) -> Void)? = nil,
        onSearchTextChanged: ((String) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onBack = onBack
        self.onTrailingTap = onTrailingTap
        self.onSearchTextChanged = onSearchTextChanged
    }

    public func makeUIView(context: Context) -> FUIAppBar {
        let view = FUIAppBar()
        view.onBack = onBack
        view.onTrailingTap = onTrailingTap
        view.onSearchTextChanged = onSearchTextChanged
        return view
    }

    public func updateUIView(_ uiView: FUIAppBar, context: Context) {
        uiView.configure(with: configuration)
    }
}
