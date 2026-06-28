import UIKit
import SwiftUI

/// 8-step type scale (color-free). UIKit `UIFont` is the source of truth; SwiftUI
/// callers use the matching `Font.fui*` tokens below so both stacks render identically.
public enum Typography {
    public static let display: UIFont = .systemFont(ofSize: 28, weight: .bold)
    public static let title: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    public static let headline: UIFont = .systemFont(ofSize: 17, weight: .semibold)
    public static let subtitle: UIFont = .systemFont(ofSize: 15, weight: .medium)
    public static let body: UIFont = .systemFont(ofSize: 14, weight: .regular)
    public static let label: UIFont = .systemFont(ofSize: 13, weight: .semibold)
    public static let caption: UIFont = .systemFont(ofSize: 12, weight: .regular)
    public static let footnote: UIFont = .systemFont(ofSize: 11, weight: .regular)
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
