import SwiftUI

/// One item in a `FUIAccordion` list.
public struct FUIAccordionItem: Identifiable {
    public let id: String
    public let title: String
    public let detail: String

    public init(id: String, title: String, detail: String) {
        self.id = id
        self.title = title
        self.detail = detail
    }
}

/// An expandable section list. Each row uses a `DisclosureGroup` styled with
/// Forge tokens: `surfaceElevated` header background, primary chevron rotation
/// animation, and `textSecondary` detail text.
public struct FUIAccordion: View {
    public let items: [FUIAccordionItem]

    public init(items: [FUIAccordionItem]) {
        self.items = items
    }

    public var body: some View {
        VStack(spacing: Spacing.none) {
            ForEach(items) { item in
                FUIAccordionRow(item: item)
                if item.id != items.last?.id {
                    Divider()
                        .background(Color(FUIColor.line))
                }
            }
        }
        .background(Color(FUIColor.surfaceElevated))
        .cornerRadius(Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Color(FUIColor.line), lineWidth: 1)
        )
    }
}

private struct FUIAccordionRow: View {
    let item: FUIAccordionItem
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: Spacing.none) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(item.title)
                        .font(.fuiLabel)
                        .foregroundColor(Color(FUIColor.textPrimary))
                    Spacer()
                    Image(systemName: FUIIcons.chevronDown)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(FUIColor.textSecondary))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(Spacing.lg)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(item.detail)
                    .font(.fuiBody)
                    .foregroundColor(Color(FUIColor.textSecondary))
                    .fixedSize(horizontal: false, vertical: true)  // wrap to multiple lines, never truncate
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, Spacing.lg)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
