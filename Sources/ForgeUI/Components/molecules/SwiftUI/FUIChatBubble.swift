import SwiftUI

/// Layout alignment for a chat bubble — mirrors `FUIBubbleVariant` in the UIKit stack.
public enum FUIChatBubbleVariant {
    /// Sent by the local user — primary background, trailing-aligned, tail on the right.
    case outbound
    /// Received from another party — surfaceElevated background, leading-aligned, tail on the left.
    case inbound
}

/// Native SwiftUI chat bubble; counterpart of the UIKit `FUIMessageBubble`.
///
/// Tail is rendered via asymmetric corner radii on the bubble's `UnevenRoundedRectangle`.
/// An optional `meta` line (timestamp / read-receipt string) appears in `.fuiFootnote`
/// below the message text.
///
/// - Note: Functional, clean, minimal animation.
public struct FUIChatBubble: View {
    public let text: String
    public let variant: FUIChatBubbleVariant
    public let meta: String?

    // Corner radius constants
    private let large: CGFloat = Radius.lg
    private let small: CGFloat = Radius.xs

    public init(text: String, variant: FUIChatBubbleVariant, meta: String? = nil) {
        self.text = text
        self.variant = variant
        self.meta = meta
    }

    private var backgroundColor: Color {
        switch variant {
        case .outbound: return Color(FUIColor.primary)
        case .inbound:  return Color(FUIColor.surfaceElevated)
        }
    }

    private var textColor: Color {
        switch variant {
        case .outbound: return Color(FUIColor.onPrimary)
        case .inbound:  return Color(FUIColor.textPrimary)
        }
    }

    private var metaColor: Color {
        switch variant {
        case .outbound: return Color(FUIColor.onPrimary).opacity(0.7)
        case .inbound:  return Color(FUIColor.textDisabled)
        }
    }

    /// Asymmetric corner radii — the "tail" corner gets a small radius.
    @available(iOS 16.0, *)
    private var bubbleShape: UnevenRoundedRectangle {
        switch variant {
        case .outbound:
            return UnevenRoundedRectangle(
                topLeadingRadius: large,
                bottomLeadingRadius: large,
                bottomTrailingRadius: small,   // tail corner
                topTrailingRadius: large
            )
        case .inbound:
            return UnevenRoundedRectangle(
                topLeadingRadius: large,
                bottomLeadingRadius: small,    // tail corner
                bottomTrailingRadius: large,
                topTrailingRadius: large
            )
        }
    }

    public var body: some View {
        HStack {
            if variant == .outbound { Spacer(minLength: Spacing.xl) }

            VStack(alignment: variant == .outbound ? .trailing : .leading, spacing: Spacing.xs) {
                Text(text)
                    .font(.fuiBody)
                    .foregroundColor(textColor)

                if let meta {
                    Text(meta)
                        .font(.fuiFootnote)
                        .foregroundColor(metaColor)
                }
            }
            .padding(.horizontal, Spacing.md - 4)
            .padding(.vertical, Spacing.sm + 2)
            .background(backgroundColor)
            .clipShape(bubbleShape)

            if variant == .inbound { Spacer(minLength: Spacing.xl) }
        }
    }
}
