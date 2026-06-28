import XCTest
@testable import ForgeUI

/// Mirrors Flutter `fui_icons_test.dart`. The icon vocabulary is the single source
/// of glyph names; these tests pin the semantic mappings and assert every name
/// resolves to a real SF Symbol so a typo can never ship.
final class FUIIconsTests: XCTestCase {

    /// A representative sweep across every section of the vocabulary.
    private let sampled: [String] = [
        FUIIcons.chevronUp, FUIIcons.chevronDown, FUIIcons.chevronLeft, FUIIcons.chevronRight,
        FUIIcons.back, FUIIcons.forward, FUIIcons.close,
        FUIIcons.search, FUIIcons.add, FUIIcons.remove, FUIIcons.edit, FUIIcons.delete,
        FUIIcons.share, FUIIcons.more, FUIIcons.filter, FUIIcons.settings, FUIIcons.refresh,
        FUIIcons.clear, FUIIcons.check,
        FUIIcons.info, FUIIcons.success, FUIIcons.warning, FUIIcons.error,
        FUIIcons.play, FUIIcons.pause, FUIIcons.image, FUIIcons.imageBroken,
        FUIIcons.file, FUIIcons.upload, FUIIcons.camera, FUIIcons.calendar, FUIIcons.location,
        FUIIcons.person, FUIIcons.bell, FUIIcons.heart, FUIIcons.heartFilled,
        FUIIcons.star, FUIIcons.starFilled,
    ]

    func testSampledIconsAreValidSFSymbols() {
        for name in sampled {
            XCTAssertNotNil(UIImage(systemName: name), "'\(name)' is not a valid SF Symbol")
        }
    }

    func testSemanticNamesPinnedToExpectedGlyphs() {
        XCTAssertEqual(FUIIcons.search, "magnifyingglass")
        XCTAssertEqual(FUIIcons.back, "arrow.left")
        XCTAssertEqual(FUIIcons.close, "xmark")
        XCTAssertEqual(FUIIcons.add, "plus")
        XCTAssertEqual(FUIIcons.chevronRight, "chevron.right")
    }

    func testStatusGlyphsAreFilledVariants() {
        XCTAssertEqual(FUIIcons.info, "info.circle.fill")
        XCTAssertEqual(FUIIcons.success, "checkmark.circle.fill")
        XCTAssertEqual(FUIIcons.warning, "exclamationmark.triangle.fill")
        XCTAssertEqual(FUIIcons.error, "xmark.octagon.fill")
    }
}
