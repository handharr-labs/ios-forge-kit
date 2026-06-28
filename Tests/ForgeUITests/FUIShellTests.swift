import XCTest
@testable import ForgeUI

/// Mirrors Flutter `fui_shell_test.dart` / `fui_app_bar_test.dart`. The app bar's
/// three variants, back button, and trailing icon buttons are all observable.
@MainActor
final class FUIShellTests: XCTestCase {

    func testTextVariantShowsTitle() {
        let bar = FUIAppBar()
        bar.configure(with: .init(variant: .text("Inbox")))
        XCTAssertNotNil(bar.fui_visibleLabel(text: "Inbox"))
    }

    func testSearchVariantHidesTitleAndShowsField() {
        let bar = FUIAppBar()
        bar.configure(with: .init(variant: .search("Search messages")))
        // No visible title label.
        XCTAssertNil(bar.fui_subviews(ofType: UILabel.self).first { !$0.isHidden && !($0.text ?? "").isEmpty })
        // A visible search text field is present.
        let field = bar.fui_subviews(ofType: UITextField.self).first { !$0.isHidden }
        XCTAssertNotNil(field)
    }

    func testLogoVariantShowsImageAndHidesTitle() {
        let bar = FUIAppBar()
        let logo = UIImage(systemName: FUIIcons.star)
        bar.configure(with: .init(variant: .logo(logo)))
        let visibleImage = bar.fui_subviews(ofType: UIImageView.self).first { !$0.isHidden && $0.image != nil }
        XCTAssertNotNil(visibleImage)
        XCTAssertNil(bar.fui_subviews(ofType: UILabel.self).first { !$0.isHidden && !($0.text ?? "").isEmpty })
    }

    func testBackButtonHiddenByDefault() {
        let bar = FUIAppBar()
        bar.configure(with: .init(variant: .text("Title"), showsBack: false))
        let visibleButtons = bar.fui_subviews(ofType: UIButton.self).filter { !$0.isHidden }
        XCTAssertTrue(visibleButtons.isEmpty)
    }

    func testBackButtonShownWhenRequested() {
        let bar = FUIAppBar()
        bar.configure(with: .init(variant: .text("Title"), showsBack: true))
        let visibleButtons = bar.fui_subviews(ofType: UIButton.self).filter { !$0.isHidden }
        XCTAssertEqual(visibleButtons.count, 1)
    }

    func testTrailingIconsProduceButtons() {
        let bar = FUIAppBar()
        bar.configure(with: .init(
            variant: .text("Title"),
            trailingIconNames: [FUIIcons.search, FUIIcons.more]
        ))
        let stack = bar.fui_firstSubview(ofType: UIStackView.self)
        XCTAssertEqual(stack?.arrangedSubviews.count, 2)
    }

    func testTrailingButtonsRebuiltOnReconfigure() {
        let bar = FUIAppBar()
        bar.configure(with: .init(variant: .text("A"), trailingIconNames: [FUIIcons.search, FUIIcons.more]))
        bar.configure(with: .init(variant: .text("B"), trailingIconNames: [FUIIcons.bell]))
        let stack = bar.fui_firstSubview(ofType: UIStackView.self)
        XCTAssertEqual(stack?.arrangedSubviews.count, 1, "trailing stack must be rebuilt, not appended")
    }

    func testBackTapInvokesCallback() {
        let bar = FUIAppBar()
        bar.configure(with: .init(variant: .text("Title"), showsBack: true))
        var backTapped = false
        bar.onBack = { backTapped = true }
        let backButton = bar.fui_subviews(ofType: UIButton.self).first { !$0.isHidden }
        backButton?.fui_fireActions(for: .touchUpInside)
        XCTAssertTrue(backTapped)
    }
}
