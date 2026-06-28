import Foundation

public struct FUIAudioPlayerConfiguration {
    public let duration: String
    public let isPlaying: Bool
    public let variant: FUIBubbleVariant  // shares outgoing/incoming styling with FUIMessageBubble

    public init(duration: String, isPlaying: Bool = false, variant: FUIBubbleVariant = .incoming) {
        self.duration = duration
        self.isPlaying = isPlaying
        self.variant = variant
    }
}
