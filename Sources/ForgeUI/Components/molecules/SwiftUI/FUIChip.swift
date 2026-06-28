import SwiftUI

/// A compact selectable/removable token — pill-shaped with an optional leading
/// icon and optional trailing remove button. Selected state uses a primary-muted
/// tonal fill with primary-colored text.
public struct FUIChip: View {
    public let label: String
    public let isSelected: Bool
    public let icon: String?
    public let onTap: (() -> Void)?
    public let onRemove: (() -> Void)?

    public init(
        _ label: String,
        isSelected: Bool = false,
        icon: String? = nil,
        onTap: (() -> Void)? = nil,
        onRemove: (() -> Void)? = nil
    ) {
        self.label = label
        self.isSelected = isSelected
        self.icon = icon
        self.onTap = onTap
        self.onRemove = onRemove
    }

    private var backgroundColor: Color {
        isSelected ? Color(FUIColor.primaryMuted) : Color(FUIColor.surfaceVariant)
    }

    private var foregroundColor: Color {
        isSelected ? Color(FUIColor.primary) : Color(FUIColor.textPrimary)
    }

    private var borderColor: Color {
        isSelected ? Color(FUIColor.primary).opacity(0.4) : Color(FUIColor.line)
    }

    public var body: some View {
        HStack(spacing: Spacing.xs) {
            if let icon {
                Image(systemName: icon)
                    .font(.fuiCaption)
                    .foregroundColor(foregroundColor)
            }

            Text(label)
                .font(.fuiLabel)
                .foregroundColor(foregroundColor)

            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: FUIIcons.close)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(foregroundColor)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(backgroundColor)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(borderColor, lineWidth: 1))
        .contentShape(Capsule())
        .onTapGesture { onTap?() }
    }
}
