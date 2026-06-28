import SwiftUI

/// A surface container that groups related content behind an elevated background,
/// rounded corners, and a 1pt line border. Border-over-shadow elevation.
public struct FUICard<Content: View>: View {
    public let padding: CGFloat
    public let content: Content

    public init(
        padding: CGFloat = Spacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(Color(FUIColor.surfaceElevated))
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg, style: .continuous)
                    .stroke(Color(FUIColor.line), lineWidth: 1)
            )
    }
}
