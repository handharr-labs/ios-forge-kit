import SwiftUI

/// General-purpose list row: a leading slot, a title with optional subtitle, optional
/// trailing meta text, and a trailing accessory slot. The whole row is the tap target
/// (`contentShape`), but the row isn't a control itself — wrap it in a `Button` or add
/// a gesture at the call site.
public struct FUIListRow<Leading: View, Trailing: View>: View {
    private let title: String
    private let subtitle: String?
    private let subtitleLineLimit: Int?
    private let meta: String?
    private let leading: Leading
    private let trailing: Trailing
    /// Extra spoken text contributed by the leading slot (e.g. a status dot's name).
    private let leadingAccessibilityLabel: String?

    public init(
        title: String,
        subtitle: String? = nil,
        subtitleLineLimit: Int? = 1,
        meta: String? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(
            title: title, subtitle: subtitle, subtitleLineLimit: subtitleLineLimit, meta: meta,
            leadingAccessibilityLabel: nil, leading: leading(), trailing: trailing()
        )
    }

    fileprivate init(
        title: String,
        subtitle: String?,
        subtitleLineLimit: Int?,
        meta: String?,
        leadingAccessibilityLabel: String?,
        leading: Leading,
        trailing: Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleLineLimit = subtitleLineLimit
        self.meta = meta
        self.leadingAccessibilityLabel = leadingAccessibilityLabel
        self.leading = leading
        self.trailing = trailing
    }

    /// Spoken summary of the row: title, subtitle, meta, then any leading-slot label.
    var accessibilityText: String {
        [title, subtitle, meta, leadingAccessibilityLabel]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            leading

            VStack(alignment: .leading, spacing: Spacing.xs) {
                FUIText(title, style: .body, lineLimit: 1)
                if let subtitle {
                    FUIText(
                        subtitle, style: .caption,
                        color: Color(FUIColor.textSecondary),
                        lineLimit: subtitleLineLimit
                    )
                }
            }

            Spacer(minLength: Spacing.sm)

            if let meta {
                FUIText(meta, style: .caption, color: Color(FUIColor.textSecondary), lineLimit: 1)
            }

            trailing
        }
        .padding(.vertical, Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }
}

// MARK: - Convenience initializers

public extension FUIListRow where Leading == FUIIcon {
    /// Leading `FUIIcons` symbol.
    init(
        title: String,
        subtitle: String? = nil,
        subtitleLineLimit: Int? = 1,
        meta: String? = nil,
        icon: String,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(
            title: title, subtitle: subtitle, subtitleLineLimit: subtitleLineLimit, meta: meta,
            leadingAccessibilityLabel: nil,
            leading: FUIIcon(icon, color: Color(FUIColor.textSecondary)),
            trailing: trailing()
        )
    }
}

public extension FUIListRow where Leading == FUIIcon, Trailing == EmptyView {
    /// Leading `FUIIcons` symbol, no trailing accessory.
    init(
        title: String,
        subtitle: String? = nil,
        subtitleLineLimit: Int? = 1,
        meta: String? = nil,
        icon: String
    ) {
        self.init(
            title: title, subtitle: subtitle, subtitleLineLimit: subtitleLineLimit, meta: meta,
            icon: icon, trailing: { EmptyView() }
        )
    }
}

public extension FUIListRow where Leading == FUIStatusDot {
    /// Leading `FUIStatusDot`; the status name joins the row's accessibility label.
    init(
        title: String,
        subtitle: String? = nil,
        subtitleLineLimit: Int? = 1,
        meta: String? = nil,
        status: FUIStatus,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(
            title: title, subtitle: subtitle, subtitleLineLimit: subtitleLineLimit, meta: meta,
            leadingAccessibilityLabel: status.accessibilityName,
            leading: FUIStatusDot(status: status),
            trailing: trailing()
        )
    }
}

public extension FUIListRow where Leading == FUIStatusDot, Trailing == EmptyView {
    /// Leading `FUIStatusDot`, no trailing accessory.
    init(
        title: String,
        subtitle: String? = nil,
        subtitleLineLimit: Int? = 1,
        meta: String? = nil,
        status: FUIStatus
    ) {
        self.init(
            title: title, subtitle: subtitle, subtitleLineLimit: subtitleLineLimit, meta: meta,
            status: status, trailing: { EmptyView() }
        )
    }
}

public extension FUIListRow where Leading == EmptyView, Trailing == EmptyView {
    /// Text-only row.
    init(
        title: String,
        subtitle: String? = nil,
        subtitleLineLimit: Int? = 1,
        meta: String? = nil
    ) {
        self.init(
            title: title, subtitle: subtitle, subtitleLineLimit: subtitleLineLimit, meta: meta,
            leading: { EmptyView() }, trailing: { EmptyView() }
        )
    }
}
