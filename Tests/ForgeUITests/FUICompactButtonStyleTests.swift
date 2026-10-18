import XCTest
import SwiftUI
@testable import ForgeUI

/// `FUICompactButtonStyle` renders smaller than the standard `FUIButtonStyle` for the same label.
@MainActor
final class FUICompactButtonStyleTests: XCTestCase {

    func testCompactIsSmallerThanStandardForBothVariants() {
        for variant in [FUIButtonVariant.filled, .outlined] {
            let standard = fui_fittingSize(
                of: Button("Run now") {}.buttonStyle(FUIButtonStyle(variant: variant)))
            let compact = fui_fittingSize(
                of: Button("Run now") {}.buttonStyle(FUICompactButtonStyle(variant: variant)))
            XCTAssertGreaterThan(compact.width, 0)
            XCTAssertLessThan(compact.width, standard.width)
            XCTAssertLessThan(compact.height, standard.height)
        }
    }

    func testDefaultVariantIsOutlined() {
        XCTAssertEqual(FUICompactButtonStyle().variant, .outlined)
    }

    func testViewExtensionAppliesStyleAndRenders() {
        let size = fui_fittingSize(of: Button("Edit") {}.fuiCompactButtonStyle(.filled))
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testDisabledButtonStillRenders() {
        let size = fui_fittingSize(of: Button("Pause") {}.fuiCompactButtonStyle().disabled(true))
        XCTAssertGreaterThan(size.width, 0)
    }
}
