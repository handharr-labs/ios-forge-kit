import SwiftUI
import UIKit

/// Visual treatment for `FUIIconButton`.
/// - `plain`:  no background, icon in `textPrimary`.
/// - `tonal`:  `primaryMuted` circular background, icon in `primary`.
/// - `filled`: `primary` circular background, icon in `onPrimary`.
public enum FUIIconButtonVariant {
    case plain
    case tonal
    case filled
}

/// Circular tappable icon button. Pass an `FUIIcons.*` string as `icon`.
/// Tap feedback via opacity press animation; no scale spring.
public struct FUIIconButton: View {
    private let icon: String
    private let variant: FUIIconButtonVariant
    private let action: () -> Void

    /// Hit-target diameter (44 pt for accessibility; glyph is 20 pt inside).
    private let diameter: CGFloat = 44
    private let glyphSize: CGFloat = 20

    public init(
        icon: String,
        variant: FUIIconButtonVariant = .plain,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.variant = variant
        self.action = action
    }

    private var iconColor: Color {
        switch variant {
        case .plain:   return Color(FUIColor.textPrimary)
        case .tonal:   return Color(FUIColor.primary)
        case .filled:  return Color(FUIColor.onPrimary)
        }
    }

    private var background: Color {
        switch variant {
        case .plain:   return .clear
        case .tonal:   return Color(FUIColor.primaryMuted)
        case .filled:  return Color(FUIColor.primary)
        }
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: glyphSize, height: glyphSize)
                .foregroundColor(iconColor)
                .frame(width: diameter, height: diameter)
                .background(background)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
