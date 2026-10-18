#if os(macOS)
import SwiftUI
import ForgeUI

/// Uppercase caption-style section title with an optional trailing count. For list
/// sections and panel groups; the count is hidden when `nil`.
public struct FUISectionHeader: View {
    private let title: String
    private let count: Int?

    public init(_ title: String, count: Int? = nil) {
        self.title = title
        self.count = count
    }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            FUIText(title.uppercased(), style: .caption, color: Color(FUIColor.textSecondary), lineLimit: 1)
            Spacer(minLength: Spacing.sm)
            if let count {
                FUIText("\(count)", style: .caption, color: Color(FUIColor.textDisabled), lineLimit: 1)
            }
        }
        .padding(.vertical, Spacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}
#endif
