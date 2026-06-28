import SwiftUI
import UIKit

/// Square checkbox backed by `FUIIcons.checkboxOn/checkboxOff` SF Symbols.
/// Checked state tints with `FUIColor.primary`; disabled state uses
/// `FUIColor.textDisabled`. Caller owns the `isChecked` state.
public struct FUICheckbox: View {
    private let isChecked: Bool
    private let isEnabled: Bool
    private let onChanged: (Bool) -> Void

    public init(
        isChecked: Bool,
        isEnabled: Bool = true,
        onChanged: @escaping (Bool) -> Void
    ) {
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }

    private var iconName: String {
        isChecked ? FUIIcons.checkboxOn : FUIIcons.checkboxOff
    }

    private var iconColor: Color {
        guard isEnabled else { return Color(FUIColor.textDisabled) }
        return isChecked ? Color(FUIColor.primary) : Color(FUIColor.textSecondary)
    }

    public var body: some View {
        Button {
            if isEnabled { onChanged(!isChecked) }
        } label: {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(iconColor)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
