import Foundation

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

public struct FUIAvatarConfiguration {
    public let name: String
    public let imageURL: URL?
    public let size: FUIAvatarSize

    public init(name: String, imageURL: URL? = nil, size: FUIAvatarSize = .medium) {
        self.name = name
        self.imageURL = imageURL
        self.size = size
    }
}
