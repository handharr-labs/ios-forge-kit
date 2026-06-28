import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUIOtpField`. See `Bridge/README.md`.
public struct FUIOtpFieldRepresentable: UIViewRepresentable {
    public let configuration: FUIOtpFieldConfiguration
    public var onChanged: ((String) -> Void)?
    public var onCompleted: ((String) -> Void)?

    public init(
        configuration: FUIOtpFieldConfiguration = .init(),
        onChanged: ((String) -> Void)? = nil,
        onCompleted: ((String) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onChanged = onChanged
        self.onCompleted = onCompleted
    }

    public func makeUIView(context: Context) -> FUIOtpField {
        let view = FUIOtpField()
        view.onChanged = onChanged
        view.onCompleted = onCompleted
        view.configure(with: configuration)
        return view
    }

    public func updateUIView(_ uiView: FUIOtpField, context: Context) {}
}
