import SwiftUI
import UIKit

/// Small static status pill. Background is the status `fill` (low-alpha tint);
/// text is the status `onFill` color. Fully static — use `FUIBadge` for counts.
public struct FUITag: View {
    private let text: String
    private let status: FUIStatus

    public init(_ text: String, status: FUIStatus = .neutral) {
        self.text = text
        self.status = status
    }

    public var body: some View {
        Text(text)
            .font(.fuiFootnote)
            .foregroundColor(status.swiftUIOnFill)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(status.swiftUIFill)
            .clipShape(Capsule())
    }
}
