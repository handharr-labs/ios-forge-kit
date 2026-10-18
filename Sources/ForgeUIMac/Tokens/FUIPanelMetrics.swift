#if os(macOS)
import CoreGraphics

/// Sizing tokens for `FUIPanel` (menu-bar-extra / popover content).
public enum FUIPanelMetrics {
    /// Fixed panel width.
    public static let width: CGFloat = 320
    /// Tallest the scrollable content area grows before it scrolls.
    public static let maxContentHeight: CGFloat = 360
}
#endif
