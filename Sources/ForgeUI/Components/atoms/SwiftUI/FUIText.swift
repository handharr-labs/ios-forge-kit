import SwiftUI
import UIKit

/// Maps the 8-step type scale to a SwiftUI-native typographic label.
/// Use `FUITextStyle` to select the weight/size tier; `color` defaults to
/// `textPrimary` and can be overridden per-call site.
public enum FUITextStyle {
    case display
    case title
    case headline
    case subtitle
    case body
    case label
    case caption
    case footnote

    var font: Font {
        switch self {
        case .display:  return .fuiDisplay
        case .title:    return .fuiTitle
        case .headline: return .fuiHeadline
        case .subtitle: return .fuiSubtitle
        case .body:     return .fuiBody
        case .label:    return .fuiLabel
        case .caption:  return .fuiCaption
        case .footnote: return .fuiFootnote
        }
    }
}

/// Token-driven typographic label. Renders `text` at the chosen `FUITextStyle`
/// tier with an optional color override and line limit.
public struct FUIText: View {
    private let text: String
    private let style: FUITextStyle
    private let color: Color
    private let lineLimit: Int?

    public init(
        _ text: String,
        style: FUITextStyle = .body,
        color: Color? = nil,
        lineLimit: Int? = nil
    ) {
        self.text = text
        self.style = style
        self.color = color ?? Color(FUIColor.textPrimary)
        self.lineLimit = lineLimit
    }

    public var body: some View {
        Text(text)
            .font(style.font)
            .foregroundColor(color)
            .lineLimit(lineLimit)
    }
}
