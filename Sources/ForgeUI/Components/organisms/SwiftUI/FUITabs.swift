import SwiftUI

/// One page in a `FUITabs` component.
public struct FUITab {
    public let title: String
    public let view: AnyView

    public init(title: String, view: AnyView) {
        self.title = title
        self.view = view
    }
}

/// A top tab bar with a primary underline indicator plus swipeable page content.
/// The selected tab label renders in `primary`; inactive tabs use `textSecondary`.
public struct FUITabs: View {
    public let tabs: [FUITab]
    @Binding public var selection: Int

    public init(tabs: [FUITab], selection: Binding<Int>) {
        self.tabs = tabs
        self._selection = selection
    }

    public var body: some View {
        VStack(spacing: Spacing.none) {
            // Tab bar
            HStack(spacing: Spacing.none) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = index
                        }
                    } label: {
                        VStack(spacing: Spacing.none) {
                            Text(tab.title)
                                .font(.fuiLabel)
                                .foregroundColor(
                                    selection == index
                                        ? Color(FUIColor.primary)
                                        : Color(FUIColor.textSecondary)
                                )
                                .padding(.horizontal, Spacing.md)
                                .padding(.vertical, Spacing.sm)
                            Rectangle()
                                .fill(
                                    selection == index
                                        ? Color(FUIColor.primary)
                                        : Color.clear
                                )
                                .frame(height: 2)
                        }
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            Divider()
                .background(Color(FUIColor.line))

            // Page content
            TabView(selection: $selection) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    tab.view
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}
