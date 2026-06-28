import XCTest
import SwiftUI
@testable import ForgeUI

/// Mirrors Flutter `fui_tokens_test.dart`. Verifies the token scales and — the
/// native equivalent of Flutter's brightness tests — that semantic colors resolve
/// to different values in light vs dark.
final class FUITokensTests: XCTestCase {

    // MARK: - Spacing

    func testSpacingScaleExactValues() {
        XCTAssertEqual(Spacing.none, 0)
        XCTAssertEqual(Spacing.xs, 4)
        XCTAssertEqual(Spacing.sm, 8)
        XCTAssertEqual(Spacing.md, 16)
        XCTAssertEqual(Spacing.lg, 24)
        XCTAssertEqual(Spacing.xl, 32)
        XCTAssertEqual(Spacing.xxl, 48)
        XCTAssertEqual(Spacing.xxxl, 64)
    }

    func testSpacingScaleStrictlyIncreasing() {
        let scale = [Spacing.none, Spacing.xs, Spacing.sm, Spacing.md,
                     Spacing.lg, Spacing.xl, Spacing.xxl, Spacing.xxxl]
        XCTAssertEqual(scale, scale.sorted())
        XCTAssertEqual(Set(scale).count, scale.count, "Spacing steps must be distinct")
    }

    func testSpacingFollowsEightPointGridFromMedium() {
        // md and up are multiples of 8 (the 8pt grid); xs/sm are the 4pt half-steps.
        for value in [Spacing.md, Spacing.lg, Spacing.xl, Spacing.xxl, Spacing.xxxl] {
            XCTAssertEqual(value.truncatingRemainder(dividingBy: 8), 0)
        }
    }

    // MARK: - Radius

    func testRadiusScaleExactValues() {
        XCTAssertEqual(Radius.xs, 4)
        XCTAssertEqual(Radius.sm, 8)
        XCTAssertEqual(Radius.md, 12)
        XCTAssertEqual(Radius.lg, 16)
        XCTAssertEqual(Radius.xl, 24)
    }

    func testRadiusFullIsPillSized() {
        XCTAssertGreaterThan(Radius.full, Radius.xl)
        XCTAssertGreaterThanOrEqual(Radius.full, 999)
    }

    func testRadiusScaleStrictlyIncreasing() {
        let scale = [Radius.xs, Radius.sm, Radius.md, Radius.lg, Radius.xl, Radius.full]
        XCTAssertEqual(scale, scale.sorted())
    }

    // MARK: - Typography

    func testTypographySizes() {
        XCTAssertEqual(Typography.display.pointSize, 28)
        XCTAssertEqual(Typography.title.pointSize, 16)
        XCTAssertEqual(Typography.headline.pointSize, 17)
        XCTAssertEqual(Typography.subtitle.pointSize, 15)
        XCTAssertEqual(Typography.body.pointSize, 14)
        XCTAssertEqual(Typography.label.pointSize, 13)
        XCTAssertEqual(Typography.caption.pointSize, 12)
        XCTAssertEqual(Typography.footnote.pointSize, 11)
    }

    func testTypographyDisplayIsLargestAndBold() {
        let sizes = [Typography.display, Typography.headline, Typography.title,
                     Typography.subtitle, Typography.body, Typography.label,
                     Typography.caption, Typography.footnote].map(\.pointSize)
        XCTAssertEqual(Typography.display.pointSize, sizes.max())
        let traits = Typography.display.fontDescriptor.symbolicTraits
        XCTAssertTrue(traits.contains(.traitBold))
    }

    // MARK: - Color: brightness-aware resolution

    func testSurfaceResolvesDifferentlyInLightAndDark() {
        let light = fui_resolve(FUIColor.surface, .light)
        let dark = fui_resolve(FUIColor.surface, .dark)
        XCTAssertNotEqual(light, dark, "surface must adapt to interface style (dark mode for free)")
    }

    func testTextPrimaryResolvesDifferentlyInLightAndDark() {
        XCTAssertNotEqual(fui_resolve(FUIColor.textPrimary, .light),
                          fui_resolve(FUIColor.textPrimary, .dark))
    }

    func testElevatedSurfaceResolvesDifferentlyInLightAndDark() {
        XCTAssertNotEqual(fui_resolve(FUIColor.surfaceElevated, .light),
                          fui_resolve(FUIColor.surfaceElevated, .dark))
    }

    func testBrandPrimaryIsFixedAcrossInterfaceStyles() {
        // The brand color is a literal RGB, not a system dynamic color: identical in both modes.
        XCTAssertEqual(fui_resolve(FUIColor.primary, .light),
                       fui_resolve(FUIColor.primary, .dark))
    }

    func testOnPrimaryIsWhite() {
        var w: CGFloat = 0, a: CGFloat = 0
        XCTAssertTrue(FUIColor.onPrimary.getWhite(&w, alpha: &a))
        XCTAssertEqual(w, 1, accuracy: 0.001)
        XCTAssertEqual(a, 1, accuracy: 0.001)
    }

    func testPrimaryMutedIsTranslucentBrand() {
        var alpha: CGFloat = 0
        FUIColor.primaryMuted.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        XCTAssertLessThan(alpha, 1, "primaryMuted is a low-alpha wash")
        XCTAssertGreaterThan(alpha, 0)
    }
}
