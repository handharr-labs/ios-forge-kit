#if os(macOS)
import XCTest
import SwiftUI
import AppKit
import ForgeUI
@testable import ForgeUIMac

/// Renders each ForgeUIMac component in an `NSHostingView` and checks sizing and the
/// sidebar badge's visibility rule (hidden for `nil` or 0).
@MainActor
final class ForgeUIMacTests: XCTestCase {

    private func fittingSize<V: View>(of view: V) -> CGSize {
        NSHostingView(rootView: view).fittingSize
    }

    // MARK: - FUISectionHeader

    func testSectionHeaderRenders() {
        let size = fittingSize(of: FUISectionHeader("Recent"))
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testSectionHeaderWithCountIsWiderThanWithout() {
        let plain = fittingSize(of: FUISectionHeader("Recent"))
        let counted = fittingSize(of: FUISectionHeader("Recent", count: 12))
        XCTAssertGreaterThan(counted.width, plain.width)
    }

    // MARK: - FUISidebarItem

    func testSidebarItemRenders() {
        let size = fittingSize(of: FUISidebarItem(title: "Inbox", icon: FUIIcons.bell))
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testSidebarBadgeVisibilityFollowsCount() {
        XCTAssertFalse(FUISidebarItem(title: "A", icon: FUIIcons.bell, badgeCount: nil).isBadgeVisible)
        XCTAssertFalse(FUISidebarItem(title: "A", icon: FUIIcons.bell, badgeCount: 0).isBadgeVisible)
        XCTAssertTrue(FUISidebarItem(title: "A", icon: FUIIcons.bell, badgeCount: 1).isBadgeVisible)
    }

    func testSidebarBadgeAffectsRenderedWidth() {
        let none = fittingSize(of: FUISidebarItem(title: "Inbox", icon: FUIIcons.bell, badgeCount: nil))
        let zero = fittingSize(of: FUISidebarItem(title: "Inbox", icon: FUIIcons.bell, badgeCount: 0))
        let some = fittingSize(of: FUISidebarItem(title: "Inbox", icon: FUIIcons.bell, badgeCount: 7))
        XCTAssertEqual(none.width, zero.width, accuracy: 0.5)
        XCTAssertGreaterThan(some.width, none.width)
    }

    // MARK: - FUIPanel

    func testPanelRendersAtFixedWidth() {
        let panel = FUIPanel(
            title: "Status",
            headerAccessory: { FUIStatusDot(status: .success) },
            content: { FUIText("Content") },
            footer: { FUIText("Footer") }
        )
        let size = fittingSize(of: panel)
        XCTAssertEqual(size.width, FUIPanelMetrics.width, accuracy: 0.5)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testPanelWithoutHeaderAccessoryRenders() {
        let panel = FUIPanel(title: "Status", content: { FUIText("Content") }, footer: { FUIText("Footer") })
        XCTAssertGreaterThan(fittingSize(of: panel).height, 0)
    }

    func testPanelHonoursCustomWidth() {
        let panel = FUIPanel(title: "T", width: 400, content: { FUIText("C") }, footer: { FUIText("F") })
        XCTAssertEqual(fittingSize(of: panel).width, 400, accuracy: 0.5)
    }

    // MARK: - ForgeUIMacCatalog

    func testCatalogRendersNonBlankContent() throws {
        // A `List` has no intrinsic size, so lay it out in a fixed frame and inspect pixels.
        let hosting = NSHostingView(rootView: ForgeUIMacCatalog())
        hosting.frame = CGRect(x: 0, y: 0, width: 480, height: 640)
        hosting.layoutSubtreeIfNeeded()
        let rep = try XCTUnwrap(hosting.bitmapImageRepForCachingDisplay(in: hosting.bounds))
        hosting.cacheDisplay(in: hosting.bounds, to: rep)
        var colors = Set<[CGFloat]>()
        for x in stride(from: 0, to: rep.pixelsWide, by: 8) {
            for y in stride(from: 0, to: rep.pixelsHigh, by: 8) {
                if let c = rep.colorAt(x: x, y: y)?.usingColorSpace(.sRGB) {
                    colors.insert([c.redComponent, c.greenComponent, c.blueComponent])
                }
            }
        }
        XCTAssertGreaterThan(colors.count, 1, "catalog rendered a single flat colour")
    }
}
#endif
