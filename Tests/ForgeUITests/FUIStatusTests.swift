import XCTest
import SwiftUI
@testable import ForgeUI

/// Covers the `FUIStatus` semantic-status primitive (the native mirror of Flutter's
/// `FUIStatus`): accent color, soft fill, on-fill content color, and leading symbol.
final class FUIStatusTests: XCTestCase {

    func testHasFiveCases() {
        XCTAssertEqual(FUIStatus.allCases.count, 5)
        XCTAssertEqual(FUIStatus.allCases, [.neutral, .info, .success, .warning, .error])
    }

    func testAccentColorMapping() {
        XCTAssertEqual(FUIStatus.neutral.color, FUIColor.textSecondary)
        XCTAssertEqual(FUIStatus.info.color, FUIColor.info)
        XCTAssertEqual(FUIStatus.success.color, FUIColor.success)
        XCTAssertEqual(FUIStatus.warning.color, FUIColor.warning)
        XCTAssertEqual(FUIStatus.error.color, FUIColor.error)
    }

    func testSymbolNameMapping() {
        XCTAssertEqual(FUIStatus.neutral.symbolName, FUIIcons.info)
        XCTAssertEqual(FUIStatus.info.symbolName, FUIIcons.info)
        XCTAssertEqual(FUIStatus.success.symbolName, FUIIcons.success)
        XCTAssertEqual(FUIStatus.warning.symbolName, FUIIcons.warning)
        XCTAssertEqual(FUIStatus.error.symbolName, FUIIcons.error)
    }

    func testEverySymbolNameIsAValidSFSymbol() {
        for status in FUIStatus.allCases {
            XCTAssertTrue(fui_symbolExists(status.symbolName),
                          "\(status) symbol '\(status.symbolName)' is not a valid SF Symbol")
        }
    }

    func testNeutralOnFillIsPrimaryText() {
        XCTAssertEqual(FUIStatus.neutral.onFill, FUIColor.textPrimary)
    }

    func testNonNeutralOnFillIsTheAccent() {
        XCTAssertEqual(FUIStatus.error.onFill, FUIStatus.error.color)
        XCTAssertEqual(FUIStatus.success.onFill, FUIStatus.success.color)
    }

    func testFillIsTranslucentForNonNeutralStatuses() {
        // Non-neutral fills are a 15% tint of the accent — alpha strictly below 1.
        let alpha = fui_rgba(FUIStatus.info.fill, dark: false).alpha
        XCTAssertEqual(alpha, 0.15, accuracy: 0.001)
    }

    func testSwiftUIAccessorsMirrorUIKitColors() {
        for status in FUIStatus.allCases {
            XCTAssertEqual(status.swiftUIColor, Color(status.color))
            XCTAssertEqual(status.swiftUIFill, Color(status.fill))
            XCTAssertEqual(status.swiftUIOnFill, Color(status.onFill))
        }
    }
}
