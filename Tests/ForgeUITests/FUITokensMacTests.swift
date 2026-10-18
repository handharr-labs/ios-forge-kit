#if os(macOS)
import XCTest
import AppKit
@testable import ForgeUI

/// macOS counterpart of the UIKit token tests: same scales, AppKit colour resolution
/// under `NSAppearance` instead of `UITraitCollection`.
final class FUITokensMacTests: XCTestCase {

    func testSpacingAndRadiusExactValues() {
        XCTAssertEqual([Spacing.none, Spacing.xs, Spacing.sm, Spacing.md,
                        Spacing.lg, Spacing.xl, Spacing.xxl, Spacing.xxxl],
                       [0, 4, 8, 16, 24, 32, 48, 64])
        XCTAssertEqual([Radius.xs, Radius.sm, Radius.md, Radius.lg, Radius.xl], [4, 8, 12, 16, 24])
        XCTAssertGreaterThanOrEqual(Radius.full, 999)
    }

    func testTypographyDisplayIsLargestAndBold() {
        let sizes = [Typography.display, Typography.headline, Typography.title,
                     Typography.subtitle, Typography.body, Typography.label,
                     Typography.caption, Typography.footnote].map(\.pointSize)
        XCTAssertEqual(Typography.display.pointSize, sizes.max())
        XCTAssertTrue(Typography.display.fontDescriptor.symbolicTraits.contains(.bold))
    }

    func testSemanticColorsResolveDifferentlyInAquaAndDarkAqua() {
        let adaptive: [(String, PlatformColor)] = [
            ("surface", FUIColor.surface),
            ("surfaceElevated", FUIColor.surfaceElevated),
            ("onSurface", FUIColor.onSurface),
            ("textPrimary", FUIColor.textPrimary),
            ("textSecondary", FUIColor.textSecondary),
        ]
        for (name, color) in adaptive {
            let light = fui_rgba(color, dark: false)
            let dark = fui_rgba(color, dark: true)
            XCTAssertNotEqual([light.red, light.green, light.blue, light.alpha],
                              [dark.red, dark.green, dark.blue, dark.alpha],
                              "\(name) must adapt to appearance")
        }
    }

    func testBrandColorsAreFixedAcrossAppearances() {
        for color in [FUIColor.primary, FUIColor.primaryVariant, FUIColor.secondary, FUIColor.primaryMuted] {
            let light = fui_rgba(color, dark: false)
            let dark = fui_rgba(color, dark: true)
            XCTAssertEqual(light.red, dark.red, accuracy: 0.001)
            XCTAssertEqual(light.green, dark.green, accuracy: 0.001)
            XCTAssertEqual(light.blue, dark.blue, accuracy: 0.001)
            XCTAssertEqual(light.alpha, dark.alpha, accuracy: 0.001)
        }
    }

    func testBrandPrimaryMatchesIOSRGB() {
        let c = fui_rgba(FUIColor.primary, dark: false)
        XCTAssertEqual(c.red, 0.22, accuracy: 0.001)
        XCTAssertEqual(c.green, 0.44, accuracy: 0.001)
        XCTAssertEqual(c.blue, 0.85, accuracy: 0.001)
    }

    func testOnPrimaryIsWhiteAndPrimaryMutedIsTranslucent() {
        let white = fui_rgba(FUIColor.onPrimary, dark: false)
        XCTAssertEqual([white.red, white.green, white.blue, white.alpha], [1, 1, 1, 1])
        let alpha = fui_rgba(FUIColor.primaryMuted, dark: false).alpha
        XCTAssertEqual(alpha, 0.12, accuracy: 0.001)
    }
}
#endif
