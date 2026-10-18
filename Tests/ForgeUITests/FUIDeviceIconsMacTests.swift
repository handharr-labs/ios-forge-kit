#if os(macOS)
import AppKit
import XCTest
@testable import ForgeUI

final class FUIDeviceIconsMacTests: XCTestCase {
    func testDeviceAndPlaybackGlyphsResolveToSFSymbols() {
        let names = [FUIIcons.device, FUIIcons.launch, FUIIcons.stop, FUIIcons.openWindow]
        for name in names {
            XCTAssertNotNil(NSImage(systemSymbolName: name, accessibilityDescription: nil),
                            "'\(name)' is not a valid SF Symbol")
        }
        XCTAssertEqual(FUIIcons.device, "iphone")
        XCTAssertEqual(FUIIcons.launch, "power")
        XCTAssertEqual(FUIIcons.stop, "stop.fill")
        XCTAssertEqual(FUIIcons.openWindow, "macwindow")
    }
}
#endif
