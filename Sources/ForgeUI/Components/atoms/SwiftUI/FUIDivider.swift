import SwiftUI
import UIKit

/// Hairline separator in `FUIColor.line`. Stretches to fill its parent along
/// the chosen axis. Use `Axis.horizontal` (default) for row separators and
/// `Axis.vertical` for column gutters.
public struct FUIDivider: View {
    private let axis: Axis

    public init(axis: Axis = .horizontal) {
        self.axis = axis
    }

    public var body: some View {
        switch axis {
        case .horizontal:
            Rectangle()
                .fill(Color(FUIColor.line))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        case .vertical:
            Rectangle()
                .fill(Color(FUIColor.line))
                .frame(width: 1)
                .frame(maxHeight: .infinity)
        }
    }
}
