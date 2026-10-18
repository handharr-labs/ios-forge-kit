import XCTest
import SwiftUI
@testable import ForgeUI

@MainActor
final class FUITextAreaTests: XCTestCase {

    private func area(
        _ text: String, placeholder: String? = nil, minLines: Int = 4,
        limit: Int? = nil, monospaced: Bool = false
    ) -> FUITextArea {
        var value = text
        let binding = Binding<String>(get: { value }, set: { value = $0 })
        return FUITextArea(
            text: binding, placeholder: placeholder, minLines: minLines,
            characterLimit: limit, isMonospaced: monospaced)
    }

    func testRendersWithNonZeroSize() {
        let size = fui_fittingSize(of: area("hello", placeholder: "Type", limit: 10))
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testPlaceholderShowsOnlyWhenEmpty() {
        XCTAssertTrue(area("", placeholder: "Type here").showsPlaceholder)
        XCTAssertFalse(area("x", placeholder: "Type here").showsPlaceholder)
        XCTAssertFalse(area("", placeholder: nil).showsPlaceholder)
        XCTAssertFalse(area("", placeholder: "").showsPlaceholder)
    }

    func testCounterTextAndOverLimit() {
        XCTAssertNil(area("abc").counterText)
        XCTAssertEqual(area("abc", limit: 10).counterText, "3 / 10")
        XCTAssertFalse(area("abcde", limit: 5).isOverLimit)
        XCTAssertTrue(area("abcdef", limit: 5).isOverLimit)
        XCTAssertFalse(area("abcdef").isOverLimit)
    }

    func testOverLimitTextIsNotTruncated() {
        let view = area(String(repeating: "a", count: 50), limit: 5)
        XCTAssertEqual(view.counterText, "50 / 5")
        XCTAssertGreaterThan(fui_fittingSize(of: view).height, 0)
    }

    func testMinLinesDrivesHeightAndIsClamped() {
        XCTAssertGreaterThan(area("", minLines: 8).minHeight, area("", minLines: 2).minHeight)
        XCTAssertEqual(area("", minLines: 0).minLines, 1)
    }

    func testMonospacedRenders() {
        XCTAssertTrue(area("x", monospaced: true).isMonospaced)
        XCTAssertGreaterThan(fui_fittingSize(of: area("x", monospaced: true)).height, 0)
    }
}
