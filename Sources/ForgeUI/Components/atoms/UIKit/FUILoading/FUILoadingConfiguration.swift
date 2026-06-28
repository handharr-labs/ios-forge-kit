import Foundation

public enum FUILoadingVariant {
    case inline      // transparent background, just spinner + optional label
    case fullscreen  // surface-tinted overlay covering the parent
}

public struct FUILoadingConfiguration {
    public let variant: FUILoadingVariant
    public let message: String?

    public init(variant: FUILoadingVariant = .inline, message: String? = nil) {
        self.variant = variant
        self.message = message
    }
}
