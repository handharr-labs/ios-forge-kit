import SwiftUI

/// A list row with a leading title/subtitle text block and a trailing radio
/// button. Fires `onSelect` with the row's `value` when tapped.
public struct FUIRadioListTile<Value: Hashable>: View {
    public let title: String
    public let subtitle: String?
    public let value: Value
    public let selection: Value
    public let onSelect: (Value) -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        value: Value,
        selection: Value,
        onSelect: @escaping (Value) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.selection = selection
        self.onSelect = onSelect
    }

    private var isSelected: Bool { value == selection }

    private var radioIcon: String {
        isSelected ? FUIIcons.radioOn : FUIIcons.radioOff
    }

    private var radioColor: Color {
        isSelected ? Color(FUIColor.primary) : Color(FUIColor.onSurfaceVariant)
    }

    public var body: some View {
        Button {
            onSelect(value)
        } label: {
            HStack(spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(.fuiBody)
                        .foregroundColor(Color(FUIColor.textPrimary))
                    if let subtitle {
                        Text(subtitle)
                            .font(.fuiCaption)
                            .foregroundColor(Color(FUIColor.textSecondary))
                    }
                }

                Spacer()

                Image(systemName: radioIcon)
                    .foregroundColor(radioColor)
                    .font(.system(size: 20))
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .padding(.vertical, Spacing.sm)
        }
        .buttonStyle(.plain)
    }
}
