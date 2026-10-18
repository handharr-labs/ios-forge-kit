import SwiftUI

/// 8-step type scale (color-free). `PlatformFont` (`UIFont` / `NSFont`) is the source of truth; SwiftUI
/// callers use the matching `Font.fui*` tokens below so both stacks render identically.
public enum Typography {
#if canImport(UIKit)
    public static let display: PlatformFont = .systemFont(ofSize: 28, weight: .bold)
    public static let title: PlatformFont = .systemFont(ofSize: 16, weight: .semibold)
    public static let headline: PlatformFont = .systemFont(ofSize: 17, weight: .semibold)
    public static let subtitle: PlatformFont = .systemFont(ofSize: 15, weight: .medium)
    public static let body: PlatformFont = .systemFont(ofSize: 14, weight: .regular)
    public static let label: PlatformFont = .systemFont(ofSize: 13, weight: .semibold)
    public static let caption: PlatformFont = .systemFont(ofSize: 12, weight: .regular)
    public static let footnote: PlatformFont = .systemFont(ofSize: 11, weight: .regular)
#else
    // NSFont isn't Sendable (UIFont is); these are immutable shared constants.
    nonisolated(unsafe) public static let display: PlatformFont = .systemFont(ofSize: 28, weight: .bold)
    nonisolated(unsafe) public static let title: PlatformFont = .systemFont(ofSize: 16, weight: .semibold)
    nonisolated(unsafe) public static let headline: PlatformFont = .systemFont(ofSize: 17, weight: .semibold)
    nonisolated(unsafe) public static let subtitle: PlatformFont = .systemFont(ofSize: 15, weight: .medium)
    nonisolated(unsafe) public static let body: PlatformFont = .systemFont(ofSize: 14, weight: .regular)
    nonisolated(unsafe) public static let label: PlatformFont = .systemFont(ofSize: 13, weight: .semibold)
    nonisolated(unsafe) public static let caption: PlatformFont = .systemFont(ofSize: 12, weight: .regular)
    nonisolated(unsafe) public static let footnote: PlatformFont = .systemFont(ofSize: 11, weight: .regular)
#endif
}

/// SwiftUI mirror of `Typography` — same sizes/weights, so a SwiftUI component
/// and its UIKit sibling share one type scale.
public extension Font {
    static let fuiDisplay = Font.system(size: 28, weight: .bold)
    static let fuiTitle = Font.system(size: 16, weight: .semibold)
    static let fuiHeadline = Font.system(size: 17, weight: .semibold)
    static let fuiSubtitle = Font.system(size: 15, weight: .medium)
    static let fuiBody = Font.system(size: 14, weight: .regular)
    static let fuiLabel = Font.system(size: 13, weight: .semibold)
    static let fuiCaption = Font.system(size: 12, weight: .regular)
    static let fuiFootnote = Font.system(size: 11, weight: .regular)
}
