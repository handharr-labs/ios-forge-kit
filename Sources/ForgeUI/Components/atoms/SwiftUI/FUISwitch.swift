import SwiftUI
import UIKit

/// On/off toggle wrapping SwiftUI `Toggle`. Tinted with `FUIColor.primary`;
/// label hidden so the caller composes its own label layout. Caller owns
/// the `isOn` state and receives changes via `onChanged`.
public struct FUISwitch: View {
    private let isOn: Bool
    private let isEnabled: Bool
    private let onChanged: (Bool) -> Void

    public init(
        isOn: Bool,
        isEnabled: Bool = true,
        onChanged: @escaping (Bool) -> Void
    ) {
        self.isOn = isOn
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }

    public var body: some View {
        Toggle(
            isOn: Binding(
                get: { isOn },
                set: { onChanged($0) }
            )
        ) {
            EmptyView()
        }
        .labelsHidden()
        .tint(Color(FUIColor.primary))
        .disabled(!isEnabled)
    }
}
