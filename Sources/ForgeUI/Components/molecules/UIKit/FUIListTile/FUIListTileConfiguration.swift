import Foundation

/// Value-type configuration for `FUIListTile`.
public struct FUIListTileConfiguration {
    public var title: String
    public var subtitle: String?
    /// SF Symbol name rendered as a 24 pt tinted icon on the leading edge.
    public var leadingIconName: String?
    /// Short text shown on the trailing edge (takes priority over `showsChevron`).
    public var trailingText: String?
    /// When `true` and `trailingText` is nil, a chevron.right glyph is shown.
    public var showsChevron: Bool

    public init(
        title: String,
        subtitle: String? = nil,
        leadingIconName: String? = nil,
        trailingText: String? = nil,
        showsChevron: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingIconName = leadingIconName
        self.trailingText = trailingText
        self.showsChevron = showsChevron
    }
}
