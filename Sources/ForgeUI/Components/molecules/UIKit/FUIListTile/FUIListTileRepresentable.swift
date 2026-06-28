import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUIListTile`. See `Bridge/README.md`.
public struct FUIListTileRepresentable: UIViewRepresentable {
    public let configuration: FUIListTileConfiguration
    public var onTap: (() -> Void)?

    public init(
        configuration: FUIListTileConfiguration,
        onTap: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onTap = onTap
    }

    public func makeUIView(context: Context) -> FUIListTile {
        let view = FUIListTile()
        view.onTap = onTap
        return view
    }

    public func updateUIView(_ uiView: FUIListTile, context: Context) {
        uiView.configure(with: configuration)
    }
}
