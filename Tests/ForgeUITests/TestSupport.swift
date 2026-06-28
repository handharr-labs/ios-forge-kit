import UIKit
import XCTest
@testable import ForgeUI

// MARK: - View-hierarchy inspection helpers
//
// ForgeUI's UIKit components keep their sub-views private (the `*Configuration`
// value type is the only public surface). These tests therefore observe behavior
// by walking the rendered view hierarchy — the iOS analog of Flutter's
// `find.text(...)` / `find.byType(...)` widget-tree finders.

extension UIView {
    /// Every view in the subtree rooted at this view (excluding `self`), depth-first.
    var fui_allSubviews: [UIView] {
        subviews.flatMap { [$0] + $0.fui_allSubviews }
    }

    /// All views of a given type anywhere in the subtree.
    func fui_subviews<T: UIView>(ofType type: T.Type) -> [T] {
        fui_allSubviews.compactMap { $0 as? T }
    }

    /// First view of a given type anywhere in the subtree.
    func fui_firstSubview<T: UIView>(ofType type: T.Type) -> T? {
        fui_subviews(ofType: type).first
    }

    /// All `UILabel` texts currently present in the subtree (visible or not).
    var fui_allLabelTexts: [String] {
        fui_subviews(ofType: UILabel.self).compactMap { $0.text }
    }

    /// True if some `UILabel` in the subtree has exactly this text.
    func fui_hasLabel(text: String) -> Bool {
        fui_allLabelTexts.contains(text)
    }

    /// First non-hidden `UILabel` with the given text, if any.
    func fui_visibleLabel(text: String) -> UILabel? {
        fui_subviews(ofType: UILabel.self).first { $0.text == text && !$0.isHidden }
    }
}

extension UIControl {
    /// Synchronously invoke every no-argument target-action registered for an event,
    /// bypassing `UIApplication`'s responder-chain dispatch (which doesn't deliver in a
    /// window-less unit-test environment). Used to exercise components' callback wiring.
    func fui_fireActions(for event: UIControl.Event) {
        for target in allTargets {
            guard let object = target as? NSObject else { continue }
            for action in actions(forTarget: target, forControlEvent: event) ?? [] {
                let selector = Selector(action)
                if object.responds(to: selector) {
                    object.perform(selector)
                }
            }
        }
    }
}

extension XCTestCase {
    /// Resolve a (possibly dynamic) `UIColor` for a concrete interface style.
    func fui_resolve(_ color: UIColor, _ style: UIUserInterfaceStyle) -> UIColor {
        color.resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
    }
}
