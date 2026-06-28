import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUIMessageBubble`. See `Bridge/README.md`.
public struct FUIMessageBubbleRepresentable: UIViewRepresentable {
    public let configuration: FUIMessageBubbleConfiguration

    public init(configuration: FUIMessageBubbleConfiguration) {
        self.configuration = configuration
    }

    public func makeUIView(context: Context) -> FUIMessageBubble {
        FUIMessageBubble()
    }

    public func updateUIView(_ uiView: FUIMessageBubble, context: Context) {
        uiView.configure(with: configuration)
    }
}
