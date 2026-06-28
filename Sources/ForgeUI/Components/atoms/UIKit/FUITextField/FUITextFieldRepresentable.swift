import SwiftUI
import UIKit

/// SwiftUI bridge for the UIKit `FUITextField`. See `Bridge/README.md`.
public struct FUITextFieldRepresentable: UIViewRepresentable {
    public let configuration: FUITextFieldConfiguration
    public var onTextChanged: ((String) -> Void)?

    public init(
        configuration: FUITextFieldConfiguration,
        onTextChanged: ((String) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onTextChanged = onTextChanged
    }

    public func makeUIView(context: Context) -> FUITextField {
        let view = FUITextField()
        view.onTextChanged = onTextChanged
        return view
    }

    public func updateUIView(_ uiView: FUITextField, context: Context) {
        uiView.configure(with: configuration)
    }
}
