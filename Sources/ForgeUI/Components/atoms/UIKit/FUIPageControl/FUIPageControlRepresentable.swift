import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUIPageControl`. See `Bridge/README.md`.
public struct FUIPageControlRepresentable: UIViewRepresentable {
    public let configuration: FUIPageControlConfiguration
    public var onPageChange: ((Int) -> Void)?

    public init(
        configuration: FUIPageControlConfiguration,
        onPageChange: ((Int) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onPageChange = onPageChange
    }

    public func makeUIView(context: Context) -> FUIPageControl {
        let view = FUIPageControl()
        view.onPageChange = onPageChange
        return view
    }

    public func updateUIView(_ uiView: FUIPageControl, context: Context) {
        uiView.configure(with: configuration)
    }
}
