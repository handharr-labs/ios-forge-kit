import SwiftUI

/// Dense button style for list rows, panels and toolbars — the compact sibling of
/// `FUIButtonStyle`. Same variants and colour tokens, with `Spacing.sm` / `Spacing.xs`
/// padding, the `fuiLabel` type token and `Radius.sm` corners. Dims when disabled.
public struct FUICompactButtonStyle: ButtonStyle {
    public let variant: FUIButtonVariant

    public init(variant: FUIButtonVariant = .outlined) {
        self.variant = variant
    }

    public func makeBody(configuration: Configuration) -> some View {
        StyledLabel(variant: variant, configuration: configuration)
    }

    private struct StyledLabel: View {
        let variant: FUIButtonVariant
        let configuration: ButtonStyleConfiguration
        @Environment(\.isEnabled) private var isEnabled

        var body: some View {
            configuration.label
                .font(.fuiLabel)
                .foregroundColor(foreground)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
                .opacity(isEnabled ? (configuration.isPressed ? 0.8 : 1) : 0.4)
        }

        @ViewBuilder private var background: some View {
            switch variant {
            case .filled:
                Color(FUIColor.primary)
            case .outlined:
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Color(FUIColor.primary), lineWidth: 1)
            }
        }

        private var foreground: Color {
            switch variant {
            case .filled:   return Color(FUIColor.onPrimary)
            case .outlined: return Color(FUIColor.primary)
            }
        }
    }
}

public extension View {
    /// Applies `FUICompactButtonStyle`.
    func fuiCompactButtonStyle(_ variant: FUIButtonVariant = .outlined) -> some View {
        buttonStyle(FUICompactButtonStyle(variant: variant))
    }
}
