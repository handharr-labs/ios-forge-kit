import SwiftUI

/// One destination item in a `FUIBottomNavBar`.
public struct FUIBottomNavItem {
    public let icon: String
    public let title: String

    public init(icon: String, title: String) {
        self.icon = icon
        self.title = title
    }
}

/// A custom bottom tab bar. Selected item renders in `primary`; others use
/// `textSecondary`. Background is `surface` with a top hairline using `line`.
public struct FUIBottomNavBar: View {
    public let items: [FUIBottomNavItem]
    public let selectedIndex: Int
    public let onSelect: (Int) -> Void

    public init(
        items: [FUIBottomNavItem],
        selectedIndex: Int,
        onSelect: @escaping (Int) -> Void
    ) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: Spacing.none) {
            Divider()
                .background(Color(FUIColor.line))
            HStack(spacing: Spacing.none) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    Button {
                        onSelect(index)
                    } label: {
                        VStack(spacing: Spacing.xs) {
                            Image(systemName: item.icon)
                                .font(.system(size: 22))
                            Text(item.title)
                                .font(.fuiFootnote)
                                .lineLimit(1)
                        }
                        .foregroundColor(
                            index == selectedIndex
                                ? Color(FUIColor.primary)
                                : Color(FUIColor.textSecondary)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.sm)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(Color(FUIColor.surface))
        }
    }
}
