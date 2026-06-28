import XCTest
import SwiftUI
@testable import ForgeUI

/// Mirrors Flutter `fui_atoms_test.dart`. Atom value types + the UIKit atoms whose
/// behavior is observable without a render harness (`FUIPrimaryButton`, `FUILoading`).
@MainActor
final class FUIAtomsTests: XCTestCase {

    // MARK: - FUIAvatarSize

    func testAvatarSizeDimensions() {
        XCTAssertEqual(FUIAvatarSize.small.dimension, 32)
        XCTAssertEqual(FUIAvatarSize.medium.dimension, 40)
        XCTAssertEqual(FUIAvatarSize.large.dimension, 48)
    }

    func testAvatarSizeFontSizes() {
        XCTAssertEqual(FUIAvatarSize.small.fontSize, 13)
        XCTAssertEqual(FUIAvatarSize.medium.fontSize, 16)
        XCTAssertEqual(FUIAvatarSize.large.fontSize, 18)
    }

    func testAvatarSizeFontScalesWithDimension() {
        XCTAssertLessThan(FUIAvatarSize.small.fontSize, FUIAvatarSize.large.fontSize)
        XCTAssertLessThan(FUIAvatarSize.small.dimension, FUIAvatarSize.large.dimension)
    }

    // MARK: - SwiftUI atom value types (public init contract)

    func testAvatarStoresInputs() {
        let url = URL(string: "https://example.com/a.png")
        let avatar = FUIAvatar(name: "Ada Lovelace", imageURL: url, size: .large)
        XCTAssertEqual(avatar.name, "Ada Lovelace")
        XCTAssertEqual(avatar.imageURL, url)
        XCTAssertEqual(avatar.size, .large)
    }

    func testAvatarDefaultsToMediumNoImage() {
        let avatar = FUIAvatar(name: "Grace Hopper")
        XCTAssertNil(avatar.imageURL)
        XCTAssertEqual(avatar.size, .medium)
    }

    func testBadgeStoresCount() {
        XCTAssertEqual(FUIBadge(count: 7).count, 7)
        XCTAssertEqual(FUIBadge(count: 0).count, 0)
    }

    func testButtonStyleVariants() {
        XCTAssertEqual(FUIButtonStyle().variant, .filled)
        XCTAssertEqual(FUIButtonStyle(variant: .outlined).variant, .outlined)
    }

    // MARK: - FUIPrimaryButton (UIKit)

    func testPrimaryButtonShowsTitleWhenNotLoading() {
        let button = FUIPrimaryButton()
        button.configure(with: .init(title: "Play", isEnabled: true, isLoading: false))
        XCTAssertEqual(button.title(for: .normal), "Play")
        XCTAssertTrue(button.isEnabled)
        XCTAssertEqual(button.backgroundColor, FUIColor.primary)
    }

    func testPrimaryButtonHidesTitleAndSpinsWhenLoading() {
        let button = FUIPrimaryButton()
        button.configure(with: .init(title: "Play", isEnabled: true, isLoading: true))
        XCTAssertNil(button.title(for: .normal))
        let spinner = button.fui_firstSubview(ofType: UIActivityIndicatorView.self)
        XCTAssertEqual(spinner?.isAnimating, true)
    }

    func testPrimaryButtonDisabledStateUsesGrayFill() {
        let button = FUIPrimaryButton()
        button.configure(with: .init(title: "Nope", isEnabled: false, isLoading: false))
        XCTAssertFalse(button.isEnabled)
        XCTAssertEqual(button.backgroundColor, .systemGray4)
    }

    // MARK: - FUILoading (UIKit)

    func testLoadingShowsMessageWhenProvided() {
        let view = FUILoading()
        view.configure(with: .init(variant: .inline, message: "Loading…"))
        XCTAssertTrue(view.fui_hasLabel(text: "Loading…"))
        XCTAssertNotNil(view.fui_visibleLabel(text: "Loading…"))
    }

    func testLoadingHidesMessageWhenNil() {
        let view = FUILoading()
        view.configure(with: .init(variant: .inline, message: nil))
        let label = view.fui_firstSubview(ofType: UILabel.self)
        XCTAssertEqual(label?.isHidden, true)
    }

    func testLoadingInlineVariantIsTransparent() {
        let view = FUILoading()
        view.configure(with: .init(variant: .inline, message: nil))
        XCTAssertEqual(view.backgroundColor, .clear)
    }

    func testLoadingFullscreenVariantHasScrim() {
        let view = FUILoading()
        view.configure(with: .init(variant: .fullscreen, message: nil))
        XCTAssertNotEqual(view.backgroundColor, .clear)
        XCTAssertNotNil(view.backgroundColor)
    }
}
