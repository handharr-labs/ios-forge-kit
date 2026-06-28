import Foundation

public enum FUIBubbleVariant {
    case outgoing  // blue background, right-aligned
    case incoming  // surface background, left-aligned
}

public struct FUIMessageBubbleConfiguration {
    public let text: String
    public let variant: FUIBubbleVariant
    public let meta: String  // combined timestamp + status string

    public init(text: String, variant: FUIBubbleVariant, meta: String) {
        self.text = text
        self.variant = variant
        self.meta = meta
    }
}
