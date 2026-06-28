import SwiftUI

/// A list row with a leading title/subtitle text block and a trailing toggle
/// switch. Fires `onChanged` with the new boolean value when the toggle changes.
public struct FUIToggleListTile: View {
    public let title: String
    public let subtitle: String?
    public let isOn: Bool
    public let isEnabled: Bool
    public let onChanged: (Bool) -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        isOn: Bool,
        isEnabled: Bool = true,
        onChanged: @escaping (Bool) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isOn = isOn
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }

    // Binding bridge so SwiftUI Toggle can drive the external callback.
    private var toggleBinding: Binding<Bool> {
        Binding(
            get: { isOn },
            set: { onChanged($0) }
        )
    }

    public var body: some View {
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

            Toggle("", isOn: toggleBinding)
                .labelsHidden()
                .tint(Color(FUIColor.primary))
                .disabled(!isEnabled)
        }
        .padding(.vertical, Spacing.xs)
    }
}
