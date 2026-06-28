import XCTest
import SwiftUI
@testable import ForgeUI

/// Covers the UIKit ↔ SwiftUI bridge layer. `UIViewRepresentable.makeUIView` needs a
/// `Context` (no public initializer), so these tests assert the bridges' public
/// construction + callback-wiring contract rather than driving the represented view.
@MainActor
final class FUIBridgeTests: XCTestCase {

    // MARK: - SwiftUI → UIKit

    func testHostingControllerHostsRootViewWithClearBackground() {
        let host = FUIHostingController(rootView: FUIAvatar(name: "Ada"))
        host.loadViewIfNeeded()
        XCTAssertEqual(host.view.backgroundColor, .clear)
        XCTAssertEqual(host.rootView.name, "Ada")
    }

    func testHostingViewEmbedsSwiftUIInline() {
        let host = UIHostingView(rootView: FUIBadge(count: 3))
        // The hosting controller's view is added as a subview of the inline host.
        XCTAssertFalse(host.subviews.isEmpty)
    }

    // MARK: - UIKit → SwiftUI (named wrappers retain config + callbacks)

    func testTextFieldRepresentableRetainsCallback() {
        let bridge = FUITextFieldRepresentable(
            configuration: .init(label: "Email"),
            onTextChanged: { _ in }
        )
        XCTAssertEqual(bridge.configuration.label, "Email")
        XCTAssertNotNil(bridge.onTextChanged)
    }

    func testOtpFieldRepresentableRetainsCallbacks() {
        let bridge = FUIOtpFieldRepresentable(
            configuration: .init(length: 4),
            onChanged: { _ in },
            onCompleted: { _ in }
        )
        XCTAssertEqual(bridge.configuration.length, 4)
        XCTAssertNotNil(bridge.onChanged)
        XCTAssertNotNil(bridge.onCompleted)
    }

    func testPageControlRepresentableRetainsCallback() {
        let bridge = FUIPageControlRepresentable(
            configuration: .init(numberOfPages: 3, currentPage: 1),
            onPageChange: { _ in }
        )
        XCTAssertEqual(bridge.configuration.numberOfPages, 3)
        XCTAssertNotNil(bridge.onPageChange)
    }

    func testListTileRepresentableRetainsCallback() {
        let bridge = FUIListTileRepresentable(
            configuration: .init(title: "Row"),
            onTap: {}
        )
        XCTAssertEqual(bridge.configuration.title, "Row")
        XCTAssertNotNil(bridge.onTap)
    }

    func testAppBarRepresentableRetainsAllCallbacks() {
        let bridge = FUIAppBarRepresentable(
            configuration: .init(variant: .text("Inbox")),
            onBack: {},
            onTrailingTap: { _ in },
            onSearchTextChanged: { _ in }
        )
        XCTAssertNotNil(bridge.onBack)
        XCTAssertNotNil(bridge.onTrailingTap)
        XCTAssertNotNil(bridge.onSearchTextChanged)
    }

    func testCallbackFreeWrappersConstruct() {
        // These have no callbacks — just confirm the configuration round-trips.
        XCTAssertEqual(FUILoadingRepresentable(configuration: .init(message: "Hi")).configuration.message, "Hi")
        XCTAssertEqual(FUIMessageBubbleRepresentable(configuration: .init(text: "x", variant: .incoming, meta: "m")).configuration.text, "x")
        XCTAssertEqual(FUITrackRowRepresentable(configuration: .init(title: "Song", subtitle: "Artist", duration: "3:00")).configuration.title, "Song")
        XCTAssertEqual(FUIPrimaryButtonRepresentable(configuration: .init(title: "Go")).configuration.title, "Go")
    }
}
