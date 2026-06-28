import XCTest
@testable import ForgeUI

/// Mirrors Flutter `fui_list_rows_test.dart`. `FUIListTile` and `FUIMessageBubble`
/// expose their content through labels + background styling after `configure`.
@MainActor
final class FUIListRowsTests: XCTestCase {

    // MARK: - FUIListTile

    func testListTileShowsTitleAndSubtitle() {
        let tile = FUIListTile()
        tile.configure(with: .init(title: "Profile", subtitle: "Edit your details"))
        XCTAssertNotNil(tile.fui_visibleLabel(text: "Profile"))
        XCTAssertNotNil(tile.fui_visibleLabel(text: "Edit your details"))
    }

    func testListTileHidesSubtitleWhenNil() {
        let tile = FUIListTile()
        tile.configure(with: .init(title: "Profile", subtitle: nil))
        let subtitleHidden = tile.fui_subviews(ofType: UILabel.self)
            .contains { $0.isHidden }
        XCTAssertTrue(subtitleHidden)
    }

    func testListTileTrailingTextTakesPriorityOverChevron() {
        let tile = FUIListTile()
        tile.configure(with: .init(title: "Storage", trailingText: "24 GB", showsChevron: true))
        XCTAssertNotNil(tile.fui_visibleLabel(text: "24 GB"))
        // The chevron image view is hidden when trailing text wins.
        let chevron = tile.fui_subviews(ofType: UIImageView.self).first { !$0.isHidden }
        XCTAssertNil(chevron)
    }

    func testListTileShowsChevronWhenRequestedAndNoTrailingText() {
        let tile = FUIListTile()
        tile.configure(with: .init(title: "Settings", showsChevron: true))
        let visibleImage = tile.fui_subviews(ofType: UIImageView.self).first { !$0.isHidden }
        XCTAssertNotNil(visibleImage)
    }

    func testListTileIconDoesNotOverlapTitle() {
        let tile = FUIListTile()
        tile.configure(with: .init(title: "Notifications", subtitle: "Push and email", leadingIconName: FUIIcons.bell))
        tile.frame = CGRect(x: 0, y: 0, width: 320, height: 64)
        tile.layoutIfNeeded()
        let icon = tile.fui_subviews(ofType: UIImageView.self).first { !$0.isHidden }
        let title = tile.fui_subviews(ofType: UILabel.self).first { $0.text == "Notifications" }
        XCTAssertNotNil(icon); XCTAssertNotNil(title)
        // icon lives on the tile; the title lives inside a stack — compare in a shared coordinate space.
        let iconMaxX = icon!.convert(icon!.bounds, to: tile).maxX
        let titleMinX = title!.convert(title!.bounds, to: tile).minX
        XCTAssertGreaterThanOrEqual(titleMinX, iconMaxX - 0.5, "leading icon overlaps the title")
    }

    func testListTileOnTapFires() {
        let tile = FUIListTile()
        tile.configure(with: .init(title: "Tap me"))
        var tapped = false
        tile.onTap = { tapped = true }
        tile.onTap?()
        XCTAssertTrue(tapped)
    }

    // MARK: - FUIMessageBubble

    func testMessageBubbleShowsTextAndMeta() {
        let bubble = FUIMessageBubble()
        bubble.configure(with: .init(text: "Hello", variant: .incoming, meta: "10:30"))
        XCTAssertTrue(bubble.fui_hasLabel(text: "Hello"))
        XCTAssertTrue(bubble.fui_hasLabel(text: "10:30"))
    }

    func testOutgoingBubbleUsesPrimaryBackground() {
        let bubble = FUIMessageBubble()
        bubble.configure(with: .init(text: "Hi", variant: .outgoing, meta: "now"))
        XCTAssertEqual(bubble.backgroundColor, FUIColor.primary)
    }

    func testIncomingBubbleUsesElevatedSurface() {
        let bubble = FUIMessageBubble()
        bubble.configure(with: .init(text: "Hi", variant: .incoming, meta: "now"))
        XCTAssertEqual(bubble.backgroundColor, FUIColor.surfaceElevated)
    }
}
