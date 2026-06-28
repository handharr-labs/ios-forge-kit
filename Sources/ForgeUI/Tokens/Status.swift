import UIKit
import SwiftUI

/// Semantic status used by status-bearing components (badge, tag, banner, toast,
/// timeline). Mirrors the Flutter kit's `FUIStatus`; resolves to native dynamic
/// colors so dark mode comes for free.
public enum FUIStatus: CaseIterable, Sendable {
    case neutral
    case info
    case success
    case warning
    case error

    /// The accent color — for dots, icons, borders, and solid fills.
    public var color: UIColor {
        switch self {
        case .neutral: return FUIColor.textSecondary
        case .info:    return FUIColor.info
        case .success: return FUIColor.success
        case .warning: return FUIColor.warning
        case .error:   return FUIColor.error
        }
    }

    /// A low-alpha tint of the accent for soft container backgrounds.
    public var fill: UIColor {
        switch self {
        case .neutral: return UIColor.secondarySystemFill
        default:       return color.withAlphaComponent(0.15)
        }
    }

    /// Content color to sit on top of `fill`.
    public var onFill: UIColor {
        switch self {
        case .neutral: return FUIColor.textPrimary
        default:       return color
        }
    }

    /// The default SF Symbol that represents this status (leading glyph in banners/toasts).
    public var symbolName: String {
        switch self {
        case .neutral: return FUIIcons.info
        case .info:    return FUIIcons.info
        case .success: return FUIIcons.success
        case .warning: return FUIIcons.warning
        case .error:   return FUIIcons.error
        }
    }
}

public extension FUIStatus {
    /// SwiftUI accessors for the same tokens.
    var swiftUIColor: Color { Color(color) }
    var swiftUIFill: Color { Color(fill) }
    var swiftUIOnFill: Color { Color(onFill) }
}
