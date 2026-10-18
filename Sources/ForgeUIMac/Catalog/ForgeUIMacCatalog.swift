#if os(macOS)
import SwiftUI
import ForgeUI

/// Live browser of the design tokens, every ForgeUI component that builds on macOS and
/// the `ForgeUIMac` components. Embed it in any macOS window.
public struct ForgeUIMacCatalog: View {
    public init() {}

    public var body: some View {
        List {
            Section("Tokens") {
                colorRows
                typographyRows
                spacingRows
                radiusRows
            }
            Section("Atoms") { atomRows }
            Section("Molecules") { moleculeRows }
            Section("Organisms") { organismRows }
            Section("ForgeUIMac") { macRows }
        }
    }

    // MARK: - Tokens

    private var colorRows: some View {
        let swatches: [(String, PlatformColor)] = [
            ("primary", FUIColor.primary), ("secondary", FUIColor.secondary),
            ("surface", FUIColor.surface), ("surfaceElevated", FUIColor.surfaceElevated),
            ("surfaceVariant", FUIColor.surfaceVariant), ("line", FUIColor.line),
            ("info", FUIColor.info), ("success", FUIColor.success),
            ("warning", FUIColor.warning), ("error", FUIColor.error),
        ]
        return row("Color") {
            HStack(spacing: Spacing.sm) {
                ForEach(swatches, id: \.0) { name, color in
                    RoundedRectangle(cornerRadius: Radius.sm)
                        .fill(Color(color))
                        .overlay(RoundedRectangle(cornerRadius: Radius.sm).stroke(Color(FUIColor.line)))
                        .frame(width: Spacing.xl, height: Spacing.xl)
                        .help(name)
                }
            }
        }
    }

    private var typographyRows: some View {
        row("Typography") {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                FUIText("Display", style: .display)
                FUIText("Headline", style: .headline)
                FUIText("Title", style: .title)
                FUIText("Subtitle", style: .subtitle)
                FUIText("Body", style: .body)
                FUIText("Label", style: .label)
                FUIText("Caption", style: .caption)
                FUIText("Footnote", style: .footnote)
            }
        }
    }

    private var spacingRows: some View {
        row("Spacing") {
            HStack(alignment: .bottom, spacing: Spacing.sm) {
                ForEach([Spacing.xs, Spacing.sm, Spacing.md, Spacing.lg, Spacing.xl], id: \.self) { value in
                    Rectangle().fill(Color(FUIColor.primary)).frame(width: value, height: value)
                }
            }
        }
    }

    private var radiusRows: some View {
        row("Radius") {
            HStack(spacing: Spacing.sm) {
                ForEach([Radius.xs, Radius.sm, Radius.md, Radius.lg, Radius.xl], id: \.self) { value in
                    RoundedRectangle(cornerRadius: value)
                        .fill(Color(FUIColor.primaryMuted))
                        .frame(width: Spacing.xl + Spacing.sm, height: Spacing.xl + Spacing.sm)
                }
            }
        }
    }

    // MARK: - ForgeUI

    private var atomRows: some View {
        Group {
            row("FUIText") { FUIText("The quick brown fox", style: .body) }
            row("FUIIcon") {
                HStack(spacing: Spacing.md) {
                    FUIIcon(FUIIcons.bell, size: .small)
                    FUIIcon(FUIIcons.bell, size: .medium)
                    FUIIcon(FUIIcons.bell, size: .large)
                }
            }
            row("FUIIconButton") {
                HStack(spacing: Spacing.md) {
                    FUIIconButton(icon: FUIIcons.heart, variant: .plain, action: {})
                    FUIIconButton(icon: FUIIcons.heart, variant: .tonal, action: {})
                    FUIIconButton(icon: FUIIcons.heart, variant: .filled, action: {})
                }
            }
            row("FUIButton") {
                HStack(spacing: Spacing.md) {
                    Button("Filled") {}.buttonStyle(FUIButtonStyle(variant: .filled))
                    Button("Outlined") {}.buttonStyle(FUIButtonStyle(variant: .outlined))
                }
            }
            row("FUITag") {
                HStack(spacing: Spacing.sm) {
                    ForEach(FUIStatus.allCases, id: \.self) { FUITag("\($0)".capitalized, status: $0) }
                }
            }
            row("FUIStatusDot") {
                HStack(spacing: Spacing.md) {
                    ForEach(FUIStatus.allCases, id: \.self) { FUIStatusDot(status: $0) }
                    FUIStatusDot(status: .info, size: .large)
                }
            }
            row("FUIBadge") {
                HStack(spacing: Spacing.md) {
                    FUIBadge(count: 3)
                    FUIBadge(count: 120)
                }
            }
            row("FUIAvatar") {
                HStack(spacing: Spacing.md) {
                    FUIAvatar(name: "Ada Lovelace", imageURL: nil, size: .small)
                    FUIAvatar(name: "Ada Lovelace", imageURL: nil, size: .medium)
                    FUIAvatar(name: "Ada Lovelace", imageURL: nil, size: .large)
                }
            }
            row("FUIProgressIndicator") {
                FUIProgressIndicator(variant: .linear, progress: 0.4).frame(width: 160)
            }
            row("FUIDivider") { FUIDivider(axis: .horizontal) }
        }
    }

    private var moleculeRows: some View {
        Group {
            row("FUICard") {
                FUICard {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        FUIText("Card title", style: .headline)
                        FUIText("Card body text goes here.", style: .body)
                    }
                }
            }
            row("FUIListRow") {
                VStack(spacing: 0) {
                    FUIListRow(title: "Text only", subtitle: "With a subtitle", meta: "2m")
                    FUIListRow(title: "Leading icon", icon: FUIIcons.person) { FUIBadge(count: 3) }
                    FUIListRow(title: "Leading status", subtitle: "Deploy finished", status: .success)
                }
            }
            row("FUIChip") {
                HStack(spacing: Spacing.sm) {
                    FUIChip("Design")
                    FUIChip("Swift", isSelected: true)
                }
            }
            row("FUIBanner") {
                FUIBanner(message: "Action completed.", status: .success)
            }
            row("FUITimeline") {
                FUITimeline(items: [
                    FUITimelineItem(title: "Order placed", subtitle: "12:00 PM", status: .success),
                    FUITimelineItem(title: "Processing", status: .info),
                    FUITimelineItem(title: "Shipped", subtitle: "Pending", status: .neutral),
                ])
            }
        }
    }

    private var organismRows: some View {
        Group {
            row("FUIAccordion") {
                FUIAccordion(items: [
                    FUIAccordionItem(id: "a", title: "What is ForgeUI?", detail: "A token-first Swift design system."),
                    FUIAccordionItem(id: "b", title: "Does it support dark mode?", detail: "Yes, colors are dynamic."),
                ])
            }
            row("FUIEmptyState") {
                FUIEmptyState(
                    systemImageName: FUIIcons.search, title: "No results",
                    subtitle: "Try a different search", actionTitle: "Clear", action: {}
                )
            }
        }
    }

    // MARK: - ForgeUIMac

    private var macRows: some View {
        Group {
            row("FUISectionHeader") { FUISectionHeader("Recent", count: 4) }
            row("FUISidebarItem") {
                VStack(spacing: 0) {
                    FUISidebarItem(title: "Inbox", icon: FUIIcons.bell, badgeCount: 5)
                    FUISidebarItem(title: "Profile", icon: FUIIcons.person)
                }
            }
            row("FUIPanel") {
                FUIPanel(
                    title: "Status",
                    headerAccessory: { FUIStatusDot(status: .success) },
                    content: {
                        FUISectionHeader("Services", count: 2)
                        FUIListRow(title: "API", status: .success)
                        FUIListRow(title: "Worker", status: .warning)
                    },
                    footer: { Button("Refresh") {}.buttonStyle(FUIButtonStyle(variant: .outlined)) }
                )
            }
        }
    }

    // MARK: - Row

    private func row<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            FUIText(title, style: .label, color: Color(FUIColor.textSecondary))
            content()
        }
        .padding(.vertical, Spacing.xs)
    }
}
#endif
