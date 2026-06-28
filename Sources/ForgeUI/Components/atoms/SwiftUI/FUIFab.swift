import SwiftUI

/// Visual variant for `FUIFab`.
public enum FUIFabVariant {
    /// Brand-primary background (`FUIColor.primary`) with `FUIColor.onPrimary` foreground.
    case primary
    /// Elevated surface background (`FUIColor.surfaceElevated`) with `FUIColor.primary` foreground.
    case surface
}

/// Floating action button.
///
/// Regular (icon-only) when `title` is `nil`; extended (icon + label) when
/// `title` is provided. Elevated with `Elevation.mid` shadow.
public struct FUIFab: View {
    public let icon: String
    public let title: String?
    public let variant: FUIFabVariant
    public let action: () -> Void

    public init(
        icon: String,
        title: String? = nil,
        variant: FUIFabVariant = .primary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.variant = variant
        self.action = action
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary: Color(FUIColor.primary)
        case .surface: Color(FUIColor.surfaceElevated)
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary: Color(FUIColor.onPrimary)
        case .surface: Color(FUIColor.primary)
        }
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                if let title {
                    Text(title)
                        .font(.fuiLabel)
                }
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, title != nil ? Spacing.md : Spacing.sm + 2)
            .padding(.vertical, Spacing.sm + 2)
            .background(backgroundColor)
            .clipShape(title != nil ? AnyShape(Capsule()) : AnyShape(Circle()))
            .shadow(
                color: Color(FUIColor.onSurface).opacity(Double(Elevation.mid.opacity)),
                radius: Elevation.mid.radius,
                x: Elevation.mid.offset.width,
                y: Elevation.mid.offset.height
            )
        }
        .buttonStyle(.plain)
    }
}
