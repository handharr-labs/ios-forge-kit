import Foundation

/// Avatar sizing scale shared by `FUIAvatar`.
/// (Previously declared alongside the retired UIKit `FUIAvatarView`; kept here now
/// that `FUIAvatar` is the canonical SwiftUI component.)
public enum FUIAvatarSize {
    case small   // 32pt
    case medium  // 40pt
    case large   // 48pt

    public var dimension: CGFloat {
        switch self {
        case .small:  return 32
        case .medium: return 40
        case .large:  return 48
        }
    }

    public var fontSize: CGFloat {
        switch self {
        case .small:  return 13
        case .medium: return 16
        case .large:  return 18
        }
    }
}
