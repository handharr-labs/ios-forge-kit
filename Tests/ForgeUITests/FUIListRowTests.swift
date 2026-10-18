import XCTest
import SwiftUI
@testable import ForgeUI

/// Covers the SwiftUI `FUIStatusDot` atom and `FUIListRow` molecule (iOS and macOS).
@MainActor
final class FUIListRowTests: XCTestCase {

    // MARK: - FUIStatusDot

    func testStatusDotSizesAreIncreasing() {
        XCTAssertEqual(FUIStatusDotSize.small.dimension, 6)
        XCTAssertEqual(FUIStatusDotSize.medium.dimension, 8)
        XCTAssertEqual(FUIStatusDotSize.large.dimension, 12)
    }

    func testStatusDotRendersAtItsDimension() {
        for size in [FUIStatusDotSize.small, .medium, .large] {
            let fitted = fui_fittingSize(of: FUIStatusDot(status: .success, size: size))
            XCTAssertEqual(fitted.width, size.dimension, accuracy: 0.5)
            XCTAssertEqual(fitted.height, size.dimension, accuracy: 0.5)
        }
    }

    func testStatusDotAccessibilityNamePerStatus() {
        XCTAssertEqual(FUIStatus.neutral.accessibilityName, "Neutral")
        XCTAssertEqual(FUIStatus.info.accessibilityName, "Info")
        XCTAssertEqual(FUIStatus.success.accessibilityName, "Success")
        XCTAssertEqual(FUIStatus.warning.accessibilityName, "Warning")
        XCTAssertEqual(FUIStatus.error.accessibilityName, "Error")
    }

    // MARK: - FUIListRow

    func testTextOnlyRowRenders() {
        let size = fui_fittingSize(of: FUIListRow(title: "Title", subtitle: "Subtitle", meta: "2m"))
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testIconRowRenders() {
        let size = fui_fittingSize(of: FUIListRow(title: "Title", icon: FUIIcons.person))
        XCTAssertGreaterThan(size.height, 0)
    }

    func testStatusRowRenders() {
        let size = fui_fittingSize(of: FUIListRow(title: "Title", status: .warning))
        XCTAssertGreaterThan(size.height, 0)
    }

    func testGenericRowWithTrailingAccessoryRenders() {
        let row = FUIListRow(
            title: "Title", subtitle: "Subtitle",
            leading: { FUIIcon(FUIIcons.bell) },
            trailing: { FUIBadge(count: 3) }
        )
        let size = fui_fittingSize(of: row)
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testAccessibilityTextIncludesTitleAndSubtitle() {
        let row = FUIListRow(title: "Build", subtitle: "Finished in 4s")
        XCTAssertTrue(row.accessibilityText.contains("Build"))
        XCTAssertTrue(row.accessibilityText.contains("Finished in 4s"))
    }

    func testAccessibilityTextIncludesMetaAndStatusName() {
        let row = FUIListRow(title: "Build", subtitle: "Finished", meta: "2m", status: .error)
        XCTAssertEqual(row.accessibilityText, "Build, Finished, 2m, Error")
    }

    func testAccessibilityTextOmitsMissingSubtitle() {
        XCTAssertEqual(FUIListRow(title: "Only title").accessibilityText, "Only title")
    }

    func testSubtitleLineLimitIsConfigurable() {
        let long = String(repeating: "wrap ", count: 60)
        let one = fui_fittingSize(of: FUIListRow(title: "T", subtitle: long, subtitleLineLimit: 1).frame(width: 200))
        let three = fui_fittingSize(of: FUIListRow(title: "T", subtitle: long, subtitleLineLimit: 3).frame(width: 200))
        XCTAssertGreaterThan(three.height, one.height)
    }
}
