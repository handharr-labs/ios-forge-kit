import SwiftUI
import UIKit

public enum FUIButtonVariant {
    case filled
    case outlined
}

public struct FUIButtonStyle: ButtonStyle {
    public let variant: FUIButtonVariant

    public init(variant: FUIButtonVariant = .filled) {
        self.variant = variant
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(foreground)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(background)
            .cornerRadius(Radius.md)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }

    @ViewBuilder private var background: some View {
        switch variant {
        case .filled:
            Color(FUIColor.primary)
        case .outlined:
            Color.clear.overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(Color(FUIColor.primary), lineWidth: 1.5)
            )
        }
    }

    private var foreground: Color {
        switch variant {
        case .filled:   return Color(FUIColor.onPrimary)
        case .outlined: return Color(FUIColor.primary)
        }
    }
}

public extension View {
    func mdsButtonStyle(_ variant: FUIButtonVariant = .filled) -> some View {
        buttonStyle(FUIButtonStyle(variant: variant))
    }
}
