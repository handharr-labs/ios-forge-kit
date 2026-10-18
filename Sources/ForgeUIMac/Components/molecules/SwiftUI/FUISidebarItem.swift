#if os(macOS)
import SwiftUI
import ForgeUI

/// Sidebar row: `FUIIcons` symbol, title and an optional trailing `FUIBadge` count.
/// Built for `List(selection:)` sidebars — tag it at the call site (`.tag(value)`).
/// The badge is hidden when `badgeCount` is `nil` or `0`.
public struct FUISidebarItem: View {
    private let title: String
    private let icon: String
    private let badgeCount: Int?

    public init(title: String, icon: String, badgeCount: Int? = nil) {
        self.title = title
        self.icon = icon
        self.badgeCount = badgeCount
    }

    var isBadgeVisible: Bool { (badgeCount ?? 0) > 0 }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            FUIIcon(icon, size: .small, color: Color(FUIColor.textSecondary))
            FUIText(title, style: .body, lineLimit: 1)
            Spacer(minLength: Spacing.sm)
            if let badgeCount, isBadgeVisible {
                FUIBadge(count: badgeCount)
            }
        }
        .padding(.vertical, Spacing.xs)
        .contentShape(Rectangle())
    }
}
#endif
