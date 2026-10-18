#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// Semantic dynamic palette, typed as `PlatformColor` (`UIColor` on iOS, `NSColor` on macOS).
/// Brand RGB values are identical on both platforms; system semantics map as follows.
///
/// | Token                           | iOS (UIKit)                  | macOS (AppKit)                    |
/// |---------------------------------|------------------------------|-----------------------------------|
/// | surface                         | systemBackground             | windowBackgroundColor             |
/// | surfaceElevated                 | secondarySystemBackground    | controlBackgroundColor            |
/// | surfaceVariant                  | tertiarySystemBackground     | underPageBackgroundColor          |
/// | onSurface, textPrimary,         | label                        | labelColor                        |
///   onStatusFill                    |                              |                                   |
/// | onSurfaceVariant, textSecondary | secondaryLabel               | secondaryLabelColor               |
/// | textDisabled                    | tertiaryLabel                | tertiaryLabelColor                |
/// | line                            | separator                    | separatorColor                    |
/// | lineStrong                      | opaqueSeparator              | gridColor                         |
/// | info / error / warning / success| systemBlue/Red/Orange/Green  | systemBlue/Red/Orange/Green       |
/// | FUIStatus.fill (neutral)        | secondarySystemFill          | secondarySystemFill               |
public enum FUIColor {
    // Brand
    public static let primary: PlatformColor = srgb(0.22, 0.44, 0.85)
    public static let primaryVariant: PlatformColor = srgb(0.15, 0.68, 0.51)
    public static let onPrimary: PlatformColor = .white
    /// Low-alpha brand wash for tonal fills (tonal icon buttons, chips, selection states).
    public static let primaryMuted: PlatformColor = srgb(0.22, 0.44, 0.85, alpha: 0.12)

    public static let secondary: PlatformColor = srgb(0.45, 0.40, 0.85)
    public static let onSecondary: PlatformColor = .white

    #if canImport(UIKit)
    // Surface
    public static let surface: PlatformColor = .systemBackground
    public static let surfaceElevated: PlatformColor = .secondarySystemBackground
    /// A third surface step for nested fills (input wells, segmented tracks).
    public static let surfaceVariant: PlatformColor = .tertiarySystemBackground
    public static let onSurface: PlatformColor = .label
    public static let onSurfaceVariant: PlatformColor = .secondaryLabel

    // Lines / borders
    public static let line: PlatformColor = .separator
    public static let lineStrong: PlatformColor = .opaqueSeparator

    // Text
    public static let textPrimary: PlatformColor = .label
    public static let textSecondary: PlatformColor = .secondaryLabel
    public static let textDisabled: PlatformColor = .tertiaryLabel
    /// Text/icon color sitting on a status-tinted fill.
    public static let onStatusFill: PlatformColor = .label
    #else
    // Surface
    public static let surface: PlatformColor = .windowBackgroundColor
    public static let surfaceElevated: PlatformColor = .controlBackgroundColor
    /// A third surface step for nested fills (input wells, segmented tracks).
    public static let surfaceVariant: PlatformColor = .underPageBackgroundColor
    public static let onSurface: PlatformColor = .labelColor
    public static let onSurfaceVariant: PlatformColor = .secondaryLabelColor

    // Lines / borders
    public static let line: PlatformColor = .separatorColor
    public static let lineStrong: PlatformColor = .gridColor

    // Text
    public static let textPrimary: PlatformColor = .labelColor
    public static let textSecondary: PlatformColor = .secondaryLabelColor
    public static let textDisabled: PlatformColor = .tertiaryLabelColor
    /// Text/icon color sitting on a status-tinted fill.
    public static let onStatusFill: PlatformColor = .labelColor
    #endif

    // Semantic / status
    public static let info: PlatformColor = .systemBlue
    public static let error: PlatformColor = .systemRed
    public static let warning: PlatformColor = .systemOrange
    public static let success: PlatformColor = .systemGreen

    /// sRGB color on both platforms (`NSColor(red:)` would be calibrated, not sRGB).
    private static func srgb(
        _ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1
    ) -> PlatformColor {
        #if canImport(UIKit)
        PlatformColor(red: red, green: green, blue: blue, alpha: alpha)
        #else
        PlatformColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
        #endif
    }
}
