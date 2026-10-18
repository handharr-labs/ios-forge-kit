import SwiftUI

/// Diameter tier for `FUIStatusDot`.
public enum FUIStatusDotSize {
    case small   // 6pt
    case medium  // 8pt
    case large   // 12pt

    public var dimension: CGFloat {
        switch self {
        case .small:  return 6
        case .medium: return Spacing.sm
        case .large:  return 12
        }
    }
}

extension FUIStatus {
    /// Spoken name of the status, used as the accessibility label of `FUIStatusDot`.
    var accessibilityName: String {
        switch self {
        case .neutral: return "Neutral"
        case .info:    return "Info"
        case .success: return "Success"
        case .warning: return "Warning"
        case .error:   return "Error"
        }
    }
}

/// A filled circle in the status accent color — a compact health/state indicator.
/// Exposes the status name to VoiceOver so the color is never the only signal.
public struct FUIStatusDot: View {
    private let status: FUIStatus
    private let size: FUIStatusDotSize

    public init(status: FUIStatus, size: FUIStatusDotSize = .medium) {
        self.status = status
        self.size = size
    }

    public var body: some View {
        Circle()
            .fill(status.swiftUIColor)
            .frame(width: size.dimension, height: size.dimension)
            .accessibilityElement()
            .accessibilityLabel(status.accessibilityName)
    }
}
