import UIKit

public enum FUIColor {
    // Brand
    public static let primary: UIColor = UIColor(red: 0.22, green: 0.44, blue: 0.85, alpha: 1)
    public static let primaryVariant: UIColor = UIColor(red: 0.15, green: 0.68, blue: 0.51, alpha: 1)
    public static let onPrimary: UIColor = .white
    /// Low-alpha brand wash for tonal fills (tonal icon buttons, chips, selection states).
    public static let primaryMuted: UIColor = UIColor(red: 0.22, green: 0.44, blue: 0.85, alpha: 0.12)

    public static let secondary: UIColor = UIColor(red: 0.45, green: 0.40, blue: 0.85, alpha: 1)
    public static let onSecondary: UIColor = .white

    // Surface
    public static let surface: UIColor = .systemBackground
    public static let surfaceElevated: UIColor = .secondarySystemBackground
    /// A third surface step for nested fills (input wells, segmented tracks).
    public static let surfaceVariant: UIColor = .tertiarySystemBackground
    public static let onSurface: UIColor = .label
    public static let onSurfaceVariant: UIColor = .secondaryLabel

    // Lines / borders
    public static let line: UIColor = .separator
    public static let lineStrong: UIColor = .opaqueSeparator

    // Semantic / status
    public static let info: UIColor = .systemBlue
    public static let error: UIColor = .systemRed
    public static let warning: UIColor = .systemOrange
    public static let success: UIColor = .systemGreen

    // Text
    public static let textPrimary: UIColor = .label
    public static let textSecondary: UIColor = .secondaryLabel
    public static let textDisabled: UIColor = .tertiaryLabel
    /// Text/icon color sitting on a status-tinted fill.
    public static let onStatusFill: UIColor = .label
}
