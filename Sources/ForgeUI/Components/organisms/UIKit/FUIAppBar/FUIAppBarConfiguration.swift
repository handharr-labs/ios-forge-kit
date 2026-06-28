import UIKit

/// Drives which center content the app bar renders.
public enum FUIAppBarVariant {
    /// Standard title text, aligned leading.
    case text(String)
    /// Brand logo image fills the center area.
    case logo(UIImage?)
    /// Inline rounded search field replaces the title.
    case search(String)  // associated value is the placeholder
}

/// Value-type configuration for `FUIAppBar`.
public struct FUIAppBarConfiguration {
    public var variant: FUIAppBarVariant
    /// When `true` a back (arrow.left) button is shown on the leading edge.
    public var showsBack: Bool
    /// SF Symbol names rendered as icon buttons on the trailing edge, left-to-right.
    public var trailingIconNames: [String]

    public init(
        variant: FUIAppBarVariant,
        showsBack: Bool = false,
        trailingIconNames: [String] = []
    ) {
        self.variant = variant
        self.showsBack = showsBack
        self.trailingIconNames = trailingIconNames
    }
}
