#if os(macOS)
import SwiftUI
import ForgeUI

/// Fixed-width container for menu-bar-extra and popover content: a header (title plus
/// optional trailing accessory), a scrollable content area and a footer of actions,
/// separated by `FUIDivider`s. Width and content height come from `FUIPanelMetrics`.
public struct FUIPanel<HeaderAccessory: View, Content: View, Footer: View>: View {
    private let title: String
    private let width: CGFloat
    private let maxContentHeight: CGFloat
    private let headerAccessory: HeaderAccessory
    private let content: Content
    private let footer: Footer

    public init(
        title: String,
        width: CGFloat = FUIPanelMetrics.width,
        maxContentHeight: CGFloat = FUIPanelMetrics.maxContentHeight,
        @ViewBuilder headerAccessory: () -> HeaderAccessory,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.width = width
        self.maxContentHeight = maxContentHeight
        self.headerAccessory = headerAccessory()
        self.content = content()
        self.footer = footer()
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: Spacing.sm) {
                FUIText(title, style: .headline, lineLimit: 1)
                Spacer(minLength: Spacing.sm)
                headerAccessory
            }
            .padding(Spacing.md)

            FUIDivider(axis: .horizontal)

            ScrollView {
                content
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: maxContentHeight)

            FUIDivider(axis: .horizontal)

            footer
                .padding(Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: width)
        .background(Color(FUIColor.surface))
    }
}

public extension FUIPanel where HeaderAccessory == EmptyView {
    /// Panel with a title-only header.
    init(
        title: String,
        width: CGFloat = FUIPanelMetrics.width,
        maxContentHeight: CGFloat = FUIPanelMetrics.maxContentHeight,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            title: title, width: width, maxContentHeight: maxContentHeight,
            headerAccessory: { EmptyView() }, content: content, footer: footer
        )
    }
}
#endif
