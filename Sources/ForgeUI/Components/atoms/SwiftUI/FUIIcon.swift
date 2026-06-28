import SwiftUI
import UIKit

/// Sizing tier for `FUIIcon`. Matches small/medium/large glyph scales used
/// across the kit's component vocabulary.
public enum FUIIconSize {
    case small
    case medium
    case large

    var points: CGFloat {
        switch self {
        case .small:  return 16
        case .medium: return 20
        case .large:  return 28
        }
    }
}

/// Token-driven SF Symbol glyph. Pass an `FUIIcons.*` constant as `name`;
/// size and color default to medium / textPrimary.
public struct FUIIcon: View {
    private let name: String
    private let size: FUIIconSize
    private let color: Color

    public init(
        _ name: String,
        size: FUIIconSize = .medium,
        color: Color = Color(FUIColor.textPrimary)
    ) {
        self.name = name
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: size.points, height: size.points)
            .foregroundColor(color)
    }
}
