#if os(macOS)
import XCTest
import SwiftUI
import AppKit
@testable import ForgeUI

/// Renders a few SwiftUI components in an `NSHostingView` and checks they lay out
/// to a non-zero size — a compile-and-render smoke test for the macOS build.
@MainActor
final class FUIMacSmokeTests: XCTestCase {

    private func fittingSize<V: View>(of view: V) -> CGSize {
        NSHostingView(rootView: view).fittingSize
    }

    private func assertRenders<V: View>(_ view: V, _ name: String, file: StaticString = #filePath, line: UInt = #line) {
        let size = fittingSize(of: view)
        XCTAssertGreaterThan(size.width, 0, "\(name) width", file: file, line: line)
        XCTAssertGreaterThan(size.height, 0, "\(name) height", file: file, line: line)
    }

    func testTextRenders() { assertRenders(FUIText("Hello"), "FUIText") }
    func testTagRenders() { assertRenders(FUITag("Beta", status: .info), "FUITag") }
    func testBadgeRenders() { assertRenders(FUIBadge(count: 3), "FUIBadge") }
    func testCardRenders() { assertRenders(FUICard { FUIText("Card") }, "FUICard") }

    func testHiddenBadgeHasNoSize() {
        let size = fittingSize(of: FUIBadge(count: 0))
        XCTAssertEqual(size.width, 0)
        XCTAssertEqual(size.height, 0)
    }
}
#endif
