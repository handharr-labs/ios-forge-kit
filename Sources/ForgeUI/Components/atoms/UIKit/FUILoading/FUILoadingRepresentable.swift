import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUILoading`. See `Bridge/README.md`.
public struct FUILoadingRepresentable: UIViewRepresentable {
    public let configuration: FUILoadingConfiguration

    public init(configuration: FUILoadingConfiguration = .init()) {
        self.configuration = configuration
    }

    public func makeUIView(context: Context) -> FUILoading {
        FUILoading()
    }

    public func updateUIView(_ uiView: FUILoading, context: Context) {
        uiView.configure(with: configuration)
    }
}
