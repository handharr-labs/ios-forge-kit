import SwiftUI

/// A list row with a leading title/subtitle text block and a trailing checkbox.
/// The entire row is tappable and fires `onChanged` with the toggled value.
public struct FUICheckboxListTile: View {
    public let title: String
    public let subtitle: String?
    public let isChecked: Bool
    public let isEnabled: Bool
    public let onChanged: (Bool) -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        isChecked: Bool,
        isEnabled: Bool = true,
        onChanged: @escaping (Bool) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }

    private var checkboxIcon: String {
        isChecked ? FUIIcons.checkboxOn : FUIIcons.checkboxOff
    }

    private var checkboxColor: Color {
        if !isEnabled { return Color(FUIColor.textDisabled) }
        return isChecked ? Color(FUIColor.primary) : Color(FUIColor.onSurfaceVariant)
    }

    public var body: some View {
        Button {
            guard isEnabled else { return }
            onChanged(!isChecked)
        } label: {
            HStack(spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(.fuiBody)
                        .foregroundColor(
                            isEnabled
                                ? Color(FUIColor.textPrimary)
                                : Color(FUIColor.textDisabled)
                        )
                    if let subtitle {
                        Text(subtitle)
                            .font(.fuiCaption)
                            .foregroundColor(
                                isEnabled
                                    ? Color(FUIColor.textSecondary)
                                    : Color(FUIColor.textDisabled)
                            )
                    }
                }

                Spacer()

                Image(systemName: checkboxIcon)
                    .foregroundColor(checkboxColor)
                    .font(.system(size: 20))
            }
            .contentShape(Rectangle())
            .padding(.vertical, Spacing.sm)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
