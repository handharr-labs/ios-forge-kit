import XCTest
import SwiftUI
@testable import ForgeUI

@MainActor
final class FUIDialogTests: XCTestCase {

    private func dialog(isDestructive: Bool? = nil) -> FUIDialog {
        if let isDestructive {
            return FUIDialog(title: "Delete?", message: "Cannot be undone.", primaryTitle: "Delete",
                             onPrimary: {}, secondaryTitle: "Cancel", onSecondary: {}, isDestructive: isDestructive)
        }
        return FUIDialog(title: "Delete?", message: "Cannot be undone.", primaryTitle: "Delete",
                         onPrimary: {}, secondaryTitle: "Cancel", onSecondary: {})
    }

    func testDefaultIsNonDestructiveAndUsesPrimaryFill() {
        let d = dialog()
        XCTAssertFalse(d.isDestructive)
        XCTAssertEqual(d.primaryFill, FUIColor.primary)
    }

    func testDestructiveUsesErrorFill() {
        let d = dialog(isDestructive: true)
        XCTAssertTrue(d.isDestructive)
        XCTAssertEqual(d.primaryFill, FUIColor.error)
        XCTAssertNotEqual(d.primaryFill, FUIColor.primary)
    }

    func testDestructiveDialogRenders() {
        let size = fui_fittingSize(of: dialog(isDestructive: true))
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testModifierAcceptsDestructiveOptionAndDefault() {
        let host = Color.clear.frame(width: 100, height: 100)
        let destructive = host.fuiDialog(
            isPresented: .constant(true), title: "T", message: "M", primaryTitle: "Delete",
            onPrimary: {}, isDestructive: true)
        let plain = host.fuiDialog(isPresented: .constant(true), title: "T", message: "M", primaryTitle: "OK", onPrimary: {})
        XCTAssertGreaterThan(fui_fittingSize(of: destructive).height, 0)
        XCTAssertGreaterThan(fui_fittingSize(of: plain).height, 0)
    }
}
