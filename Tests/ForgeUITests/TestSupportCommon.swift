import XCTest
import SwiftUI
@testable import ForgeUI

// MARK: - Cross-platform helpers (UIKit and AppKit)

extension XCTestCase {
    /// True if `name` resolves to an SF Symbol on the current platform.
    func fui_symbolExists(_ name: String) -> Bool {
        #if canImport(UIKit)
        UIImage(systemName: name) != nil
        #else
        NSImage(systemSymbolName: name, accessibilityDescription: nil) != nil
        #endif
    }

    /// Resolve a (possibly dynamic) color to sRGB components under a light or dark appearance.
    func fui_rgba(
        _ color: PlatformColor, dark: Bool
    ) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        #if canImport(UIKit)
        let traits = UITraitCollection(userInterfaceStyle: dark ? .dark : .light)
        color.resolvedColor(with: traits).getRed(&r, green: &g, blue: &b, alpha: &a)
        #else
        NSAppearance(named: dark ? .darkAqua : .aqua)!.performAsCurrentDrawingAppearance {
            if let srgb = color.usingColorSpace(.sRGB) {
                srgb.getRed(&r, green: &g, blue: &b, alpha: &a)
            }
        }
        #endif
        return (r, g, b, a)
    }
}

extension XCTestCase {
    /// Natural size of a SwiftUI view when hosted natively (`UIHostingController` / `NSHostingView`).
    @MainActor
    func fui_fittingSize<V: View>(of view: V) -> CGSize {
        #if canImport(UIKit)
        UIHostingController(rootView: view)
            .sizeThatFits(in: CGSize(width: 320, height: CGFloat.greatestFiniteMagnitude))
        #else
        NSHostingView(rootView: view).fittingSize
        #endif
    }
}
