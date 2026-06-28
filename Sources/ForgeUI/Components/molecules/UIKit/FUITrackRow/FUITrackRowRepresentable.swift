import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUITrackRow`. See `Bridge/README.md`.
public struct FUITrackRowRepresentable: UIViewRepresentable {
    public let configuration: FUITrackRowConfiguration

    public init(configuration: FUITrackRowConfiguration) {
        self.configuration = configuration
    }

    public func makeUIView(context: Context) -> FUITrackRow {
        FUITrackRow()
    }

    public func updateUIView(_ uiView: FUITrackRow, context: Context) {
        uiView.configure(with: configuration)
    }
}
