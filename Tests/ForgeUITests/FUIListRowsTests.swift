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
