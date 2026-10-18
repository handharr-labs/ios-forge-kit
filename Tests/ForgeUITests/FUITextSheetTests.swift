import XCTest
import SwiftUI
@testable import ForgeUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

@MainActor
final class FUITextSheetTests: XCTestCase {

    private struct Doc: Identifiable { let id: Int; let body: String }

    func testRendersWithNonZeroSize() {
        let sheet = FUITextSheet(title: "Title", subtitle: "Sub", text: "Hello", onClose: {})
        let size = fui_fittingSize(of: sheet)
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testStoresTextTitleAndSubtitle() {
        let sheet = FUITextSheet(title: "First prompt", subtitle: "repo · 2m ago", text: "Some text", onClose: {})
        XCTAssertEqual(sheet.title, "First prompt")
        XCTAssertEqual(sheet.subtitle, "repo · 2m ago")
        XCTAssertEqual(sheet.text, "Some text")
        XCTAssertEqual(sheet.copyLabel, "Copy")
    }

    func testSubtitleIsOptional() {
        let sheet = FUITextSheet(title: "T", text: "x", onClose: {})
        XCTAssertNil(sheet.subtitle)
        XCTAssertGreaterThan(fui_fittingSize(of: sheet).height, 0)
    }

    func testLongTextIsNotTruncated() {
        let long = String(repeating: "lorem ipsum dolor sit amet ", count: 2_000)
        let sheet = FUITextSheet(title: "T", text: long, onClose: {})
        XCTAssertEqual(sheet.text.count, long.count)
        XCTAssertGreaterThan(fui_fittingSize(of: sheet).height, 0)
    }

    func testModifierRenders() {
        var item: Doc? = Doc(id: 1, body: "body")
        let binding = Binding<Doc?>(get: { item }, set: { item = $0 })
        let view = Color.clear.frame(width: 100, height: 100).fuiTextSheet(
            item: binding, title: { "Doc \($0.id)" }, subtitle: { _ in nil }, text: { $0.body })
        XCTAssertGreaterThan(fui_fittingSize(of: view).height, 0)
        let noSubtitle = Color.clear.fuiTextSheet(item: binding, title: { _ in "T" }, text: { $0.body })
        XCTAssertGreaterThan(fui_fittingSize(of: noSubtitle).height, 0)
    }

    #if os(macOS)
    func testCopyWritesPasteboard() {
        let pasteboard = NSPasteboard(name: NSPasteboard.Name("FUITextSheetTests-\(UUID().uuidString)"))
        defer { pasteboard.releaseGlobally() }
        let text = String(repeating: "full text ", count: 1_000)
        FUITextSheet.write(text, to: pasteboard)
        XCTAssertEqual(pasteboard.string(forType: .string), text)
    }
    #else
    func testCopyWritesPasteboard() {
        let pasteboard = UIPasteboard.withUniqueName()
        FUITextSheet.write("full text", to: pasteboard)
        XCTAssertEqual(pasteboard.string, "full text")
    }
    #endif
}
