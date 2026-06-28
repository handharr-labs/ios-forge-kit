import SwiftUI
import UIKit

/// Standalone count badge — a primary-tinted capsule rendering `count` (or "99+").
/// Renders nothing when `count <= 0`. Use `FUIBadgeModifier` / `.mdsBadge(count:)`
/// to overlay a badge on another view instead.
public struct FUIBadge: View {
    public let count: Int

    public init(count: Int) {
        self.count = count
    }

    public var body: some View {
        if count > 0 {
            Text(count > 99 ? "99+" : "\(count)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(FUIColor.onPrimary))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color(FUIColor.primary))
                .clipShape(Capsule())
        }
    }
}

public struct FUIBadgeModifier: ViewModifier {
    public let count: Int

    public init(count: Int) {
        self.count = count
    }

    public func body(content: Content) -> some View {
        content.overlay(alignment: .topTrailing) {
            if count > 0 {
                Text(count > 99 ? "99+" : "\(count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(FUIColor.onPrimary))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color(FUIColor.primary))
                    .clipShape(Capsule())
                    .offset(x: 8, y: -8)
            }
        }
    }
}

public extension View {
    func mdsBadge(count: Int) -> some View {
        modifier(FUIBadgeModifier(count: count))
    }
}
