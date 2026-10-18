import XCTest
import SwiftUI
@testable import ForgeUI

@MainActor
final class FUITextInputTests: XCTestCase {

    private func input(
        _ text: String, placeholder: String? = nil, limit: Int? = nil, monospaced: Bool = false
    ) -> FUITextInput {
        var value = text
        let binding = Binding<String>(get: { value }, set: { value = $0 })
        return FUITextInput(text: binding, placeholder: placeholder, characterLimit: limit, isMonospaced: monospaced)
    }

    func testRendersWithNonZeroSize() {
        let size = fui_fittingSize(of: input("hello", placeholder: "Name", limit: 10))
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testPlaceholderShowsOnlyWhenEmpty() {
        XCTAssertTrue(input("", placeholder: "Type here").showsPlaceholder)
        XCTAssertFalse(input("x", placeholder: "Type here").showsPlaceholder)
        XCTAssertFalse(input("", placeholder: nil).showsPlaceholder)
        XCTAssertFalse(input("", placeholder: "").showsPlaceholder)
    }

    func testCounterTextAndOverLimit() {
        XCTAssertNil(input("abc").counterText)
        XCTAssertEqual(input("abc", limit: 10).counterText, "3 / 10")
        XCTAssertFalse(input("abcde", limit: 5).isOverLimit)
        XCTAssertTrue(input("abcdef", limit: 5).isOverLimit)
        XCTAssertFalse(input("abcdef").isOverLimit)
    }

    func testOverLimitTextIsNotTruncated() {
        let view = input(String(repeating: "a", count: 50), limit: 5)
        XCTAssertEqual(view.counterText, "50 / 5")
        XCTAssertGreaterThan(fui_fittingSize(of: view).height, 0)
    }
}
