import SwiftUI
import UIKit

/// Single radio option within a group. The generic `Value` type lets the
/// caller bind any `Hashable` domain value (enum, id, string, etc.).
/// Selected state renders in `FUIColor.primary`; disabled in `textDisabled`.
/// Caller owns the `selection` state and updates it via `onSelect`.
public struct FUIRadio<Value: Hashable>: View {
    private let value: Value
    private let selection: Value
    private let isEnabled: Bool
    private let onSelect: (Value) -> Void

    public init(
        value: Value,
        selection: Value,
        isEnabled: Bool = true,
        onSelect: @escaping (Value) -> Void
    ) {
        self.value = value
        self.selection = selection
        self.isEnabled = isEnabled
        self.onSelect = onSelect
    }

    private var isSelected: Bool { value == selection }

    private var iconName: String {
        isSelected ? FUIIcons.radioOn : FUIIcons.radioOff
    }

    private var iconColor: Color {
        guard isEnabled else { return Color(FUIColor.textDisabled) }
        return isSelected ? Color(FUIColor.primary) : Color(FUIColor.textSecondary)
    }

    public var body: some View {
        Button {
            if isEnabled { onSelect(value) }
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
