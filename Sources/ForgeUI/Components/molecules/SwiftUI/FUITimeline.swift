import SwiftUI

/// A single event in an `FUITimeline`.
public struct FUITimelineItem {
    public let title: String
    public let subtitle: String?
    public let status: FUIStatus

    public init(title: String, subtitle: String? = nil, status: FUIStatus) {
        self.title = title
        self.subtitle = subtitle
        self.status = status
    }
}

/// Vertical list of events, each rendered as a status dot + connector rail +
/// title/subtitle text block.  The last item draws no trailing connector.
///
/// - Note: Functional, clean, minimal animation.
public struct FUITimeline: View {
    public let items: [FUITimelineItem]

    private let dotSize: CGFloat = 12
    private let railWidth: CGFloat = 2
    private let railColor = Color(FUIColor.line)

    public init(items: [FUITimelineItem]) {
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.none) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                itemRow(item: item, isLast: index == items.count - 1)
            }
        }
    }

    @ViewBuilder
    private func itemRow(item: FUITimelineItem, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            // Left column: dot + connector
            VStack(spacing: Spacing.none) {
                Circle()
                    .fill(item.status.swiftUIColor)
                    .frame(width: dotSize, height: dotSize)
                    .padding(.top, 3) // align dot with first text baseline

                if !isLast {
                    Rectangle()
                        .fill(railColor)
                        .frame(width: railWidth)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: dotSize)

            // Right column: text
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(item.title)
                    .font(.fuiSubtitle)
                    .foregroundColor(Color(FUIColor.textPrimary))

                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.fuiCaption)
                        .foregroundColor(Color(FUIColor.textSecondary))
                }
            }
            .padding(.bottom, isLast ? Spacing.none : Spacing.lg)
        }
    }
}
