import UIKit
import SwiftUI

/// Live in-app browser of every `ForgeUI` component. Shipped with the kit so any
/// host (the playground, or a downstream app) can present the catalog directly.
public final class ForgeUICatalogViewController: UIViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Model

    private struct CatalogItem {
        let title: String
        let makePreview: () -> UIView
    }

    private struct CatalogSection {
        let title: String
        let items: [CatalogItem]
    }

    // MARK: - State

    private lazy var sections: [CatalogSection] = makeSections()
    // Pre-built cells keyed by [section][row] — never reconfigured, never reused with different content
    private lazy var cells: [[UITableViewCell]] = sections.map { section in
        section.items.map { item in
            let cell = CatalogCell()
            cell.configure(title: item.title, preview: item.makePreview())
            return cell
        }
    }

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        return tv
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "DS Catalog"
        view.backgroundColor = FUIColor.surface
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "circle.lefthalf.filled"),
            style: .plain,
            target: self,
            action: #selector(toggleAppearance)
        )
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Light / Dark

    @objc private func toggleAppearance() {
        overrideUserInterfaceStyle = overrideUserInterfaceStyle == .dark ? .light : .dark
    }

    // MARK: - Section factory

    private func makeSections() -> [CatalogSection] {
        [
            CatalogSection(title: "Tokens", items: [
                CatalogItem(title: "Color", makePreview: makeColorPreview),
                CatalogItem(title: "Typography", makePreview: makeTypographyPreview),
                CatalogItem(title: "Spacing", makePreview: makeSpacingPreview),
                CatalogItem(title: "Radius", makePreview: makeRadiusPreview),
                CatalogItem(title: "Elevation", makePreview: makeElevationPreview),
            ]),
            CatalogSection(title: "Atoms (UIKit)", items: [
                CatalogItem(title: "FUILoading", makePreview: makeLoadingPreview),
                CatalogItem(title: "FUIPrimaryButton", makePreview: makePrimaryButtonPreview),
                CatalogItem(title: "FUITextField", makePreview: makeTextFieldPreview),
                CatalogItem(title: "FUIOtpField", makePreview: makeOtpFieldPreview),
                CatalogItem(title: "FUIPageControl", makePreview: makePageControlPreview),
            ]),
            CatalogSection(title: "Molecules (UIKit)", items: [
                CatalogItem(title: "FUIMessageBubble", makePreview: makeMessageBubblePreview),
                CatalogItem(title: "FUIAudioPlayer", makePreview: makeAudioPlayerPreview),
                CatalogItem(title: "FUIListTile", makePreview: makeListTilePreview),
            ]),
            CatalogSection(title: "Organisms (UIKit)", items: [
                CatalogItem(title: "FUIAppBar", makePreview: makeAppBarPreview),
            ]),
            CatalogSection(title: "Atoms (SwiftUI)", items: [
                CatalogItem(title: "FUIButton", makePreview: makeSUIButtonPreview),
                CatalogItem(title: "FUIAvatar", makePreview: makeSUIAvatarPreview),
                CatalogItem(title: "FUIBadge", makePreview: makeSUIBadgePreview),
                CatalogItem(title: "FUIText", makePreview: makeFUITextPreview),
                CatalogItem(title: "FUIIcon", makePreview: makeFUIIconPreview),
                CatalogItem(title: "FUIIconButton", makePreview: makeFUIIconButtonPreview),
                CatalogItem(title: "FUITag", makePreview: makeFUITagPreview),
                CatalogItem(title: "FUIDivider", makePreview: makeFUIDividerPreview),
                CatalogItem(title: "FUICheckbox", makePreview: makeFUICheckboxPreview),
                CatalogItem(title: "FUIRadio", makePreview: makeFUIRadioPreview),
                CatalogItem(title: "FUISwitch", makePreview: makeFUISwitchPreview),
                CatalogItem(title: "FUIShimmer", makePreview: makeFUIShimmerPreview),
                CatalogItem(title: "FUIProgressIndicator", makePreview: makeFUIProgressIndicatorPreview),
                CatalogItem(title: "FUISlider", makePreview: makeFUISliderPreview),
                CatalogItem(title: "fuiTooltip modifier", makePreview: makeFUITooltipPreview),
                CatalogItem(title: "FUIImage", makePreview: makeFUIImagePreview),
                CatalogItem(title: "FUIFab", makePreview: makeFUIFabPreview),
                CatalogItem(title: "FUISearchField", makePreview: makeFUISearchFieldPreview),
            ]),
            CatalogSection(title: "Molecules (SwiftUI)", items: [
                CatalogItem(title: "FUICard", makePreview: makeFUICardPreview),
                CatalogItem(title: "FUIBanner", makePreview: makeFUIBannerPreview),
                CatalogItem(title: "FUIChip", makePreview: makeFUIChipPreview),
                CatalogItem(title: "FUICheckboxListTile", makePreview: makeFUICheckboxListTilePreview),
                CatalogItem(title: "FUIRadioListTile", makePreview: makeFUIRadioListTilePreview),
                CatalogItem(title: "FUIToggleListTile", makePreview: makeFUIToggleListTilePreview),
                CatalogItem(title: "FUISegmentedControl", makePreview: makeFUISegmentedControlPreview),
                CatalogItem(title: "FUISelect", makePreview: makeFUISelectPreview),
                CatalogItem(title: "FUIStepper", makePreview: makeFUIStepperPreview),
                CatalogItem(title: "FUIToast", makePreview: makeFUIToastPreview),
                CatalogItem(title: "FUITimeline", makePreview: makeFUITimelinePreview),
                CatalogItem(title: "FUIChatBubble", makePreview: makeFUIChatBubblePreview),
                CatalogItem(title: "FUIFileUpload", makePreview: makeFUIFileUploadPreview),
                CatalogItem(title: "FUILoadingOverlay", makePreview: makeSUILoadingOverlayPreview),
            ]),
            CatalogSection(title: "Organisms (SwiftUI)", items: [
                CatalogItem(title: "FUIDialog", makePreview: makeFUIDialogPreview),
                CatalogItem(title: "FUITabs", makePreview: makeFUITabsPreview),
                CatalogItem(title: "FUIAccordion", makePreview: makeFUIAccordionPreview),
                CatalogItem(title: "FUIBottomNavBar", makePreview: makeFUIBottomNavBarPreview),
                CatalogItem(title: "fuiBottomSheet modifier", makePreview: makeFUIBottomSheetPreview),
                CatalogItem(title: "fuiContextMenu modifier", makePreview: makeFUIContextMenuPreview),
                CatalogItem(title: "FUICalendar", makePreview: makeFUICalendarPreview),
                CatalogItem(title: "fuiCountryPicker modifier", makePreview: makeFUICountryPickerPreview),
                CatalogItem(title: "FUIStories", makePreview: makeFUIStoriesPreview),
                CatalogItem(title: "FUIEmptyState", makePreview: makeSUIEmptyStatePreview),
            ]),
        ]
    }
}

// MARK: - UITableViewDataSource

extension ForgeUICatalogViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].items.count }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { sections[section].title }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cells[indexPath.section][indexPath.row]
    }
}

// MARK: - Token Previews

private extension ForgeUICatalogViewController {
    func makeColorPreview() -> UIView {
        let tokens: [(String, UIColor)] = [
            ("primary", FUIColor.primary),
            ("primaryVariant", FUIColor.primaryVariant),
            ("surface", FUIColor.surface),
            ("surfaceElevated", FUIColor.surfaceElevated),
            ("error", FUIColor.error),
            ("warning", FUIColor.warning),
            ("success", FUIColor.success),
        ]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Spacing.sm
        stack.alignment = .center
        tokens.forEach { name, color in
            let swatch = UIView()
            swatch.backgroundColor = color
            swatch.layer.cornerRadius = Radius.xs
            swatch.layer.borderWidth = 0.5
            swatch.layer.borderColor = UIColor.separator.cgColor
            swatch.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                swatch.widthAnchor.constraint(equalToConstant: 28),
                swatch.heightAnchor.constraint(equalToConstant: 28),
            ])
            let label = UILabel()
            label.text = name
            label.font = .systemFont(ofSize: 9)
            label.textColor = FUIColor.textSecondary
            label.textAlignment = .center
            let col = UIStackView(arrangedSubviews: [swatch, label])
            col.axis = .vertical
            col.spacing = 2
            col.alignment = .center
            stack.addArrangedSubview(col)
        }
        return stack
    }

    func makeTypographyPreview() -> UIView {
        let pairs: [(String, UIFont)] = [
            ("Display", Typography.display),
            ("Title", Typography.title),
            ("Body", Typography.body),
            ("Caption", Typography.caption),
        ]
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spacing.xs
        pairs.forEach { name, font in
            let label = UILabel()
            label.text = "\(name) — Aa Bb Cc"
            label.font = font
            label.textColor = FUIColor.textPrimary
            stack.addArrangedSubview(label)
        }
        return stack
    }

    func makeSpacingPreview() -> UIView {
        let tokens: [(String, CGFloat)] = [
            ("xs\n4pt", Spacing.xs),
            ("sm\n8pt", Spacing.sm),
            ("md\n16pt", Spacing.md),
            ("lg\n24pt", Spacing.lg),
            ("xl\n32pt", Spacing.xl),
        ]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Spacing.sm
        stack.alignment = .bottom
        tokens.forEach { name, size in
            let box = UIView()
            box.backgroundColor = FUIColor.primary.withAlphaComponent(0.25)
            box.layer.cornerRadius = Radius.xs
            box.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                box.widthAnchor.constraint(equalToConstant: size),
                box.heightAnchor.constraint(equalToConstant: size),
            ])
            let label = UILabel()
            label.text = name
            label.font = .systemFont(ofSize: 9)
            label.textColor = FUIColor.textSecondary
            label.textAlignment = .center
            label.numberOfLines = 2
            let col = UIStackView(arrangedSubviews: [box, label])
            col.axis = .vertical
            col.spacing = Spacing.xs
            col.alignment = .center
            stack.addArrangedSubview(col)
        }
        return stack
    }

    func makeRadiusPreview() -> UIView {
        let tokens: [(String, CGFloat)] = [
            ("xs\n4", Radius.xs),
            ("sm\n8", Radius.sm),
            ("md\n12", Radius.md),
            ("lg\n16", Radius.lg),
            ("full\n∞", Radius.full),
        ]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Spacing.md
        stack.alignment = .center
        tokens.forEach { name, radius in
            let box = UIView()
            box.backgroundColor = FUIColor.primary.withAlphaComponent(0.15)
            box.layer.cornerRadius = min(radius, 24)
            box.layer.borderWidth = 1.5
            box.layer.borderColor = FUIColor.primary.cgColor
            box.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                box.widthAnchor.constraint(equalToConstant: 48),
                box.heightAnchor.constraint(equalToConstant: 48),
            ])
            let label = UILabel()
            label.text = name
            label.font = .systemFont(ofSize: 9)
            label.textColor = FUIColor.textSecondary
            label.textAlignment = .center
            label.numberOfLines = 2
            let col = UIStackView(arrangedSubviews: [box, label])
            col.axis = .vertical
            col.spacing = Spacing.xs
            col.alignment = .center
            stack.addArrangedSubview(col)
        }
        return stack
    }

    func makeElevationPreview() -> UIView {
        let tokens: [(String, ShadowToken)] = [
            ("low", Elevation.low),
            ("mid", Elevation.mid),
            ("high", Elevation.high),
        ]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Spacing.xl
        stack.alignment = .center
        tokens.forEach { name, shadow in
            let box = UIView()
            box.backgroundColor = FUIColor.surfaceElevated
            box.layer.cornerRadius = Radius.md
            box.applyShadow(shadow)
            box.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                box.widthAnchor.constraint(equalToConstant: 60),
                box.heightAnchor.constraint(equalToConstant: 40),
            ])
            let label = UILabel()
            label.text = name
            label.font = Typography.caption
            label.textColor = FUIColor.textSecondary
            label.textAlignment = .center
            let col = UIStackView(arrangedSubviews: [box, label])
            col.axis = .vertical
            col.spacing = Spacing.sm
            col.alignment = .center
            stack.addArrangedSubview(col)
        }
        return stack
    }
}

// MARK: - UIKit Component Previews

private extension ForgeUICatalogViewController {
    func makeLoadingPreview() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Spacing.xl
        stack.alignment = .center
        let inlineView = FUILoading()
        inlineView.configure(with: FUILoadingConfiguration(variant: .inline, message: "Loading…"))
        let inlineLbl = UILabel()
        inlineLbl.text = "inline"
        inlineLbl.font = Typography.caption
        inlineLbl.textColor = FUIColor.textSecondary
        inlineLbl.textAlignment = .center
        let inlineCol = UIStackView(arrangedSubviews: [inlineView, inlineLbl])
        inlineCol.axis = .vertical
        inlineCol.spacing = Spacing.xs
        inlineCol.alignment = .center
        stack.addArrangedSubview(inlineCol)
        return stack
    }

    func makeMessageBubblePreview() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spacing.sm
        stack.alignment = .fill
        let outgoing = FUIMessageBubble()
        outgoing.configure(with: FUIMessageBubbleConfiguration(
            text: "Hey! How's it going?",
            variant: .outgoing,
            meta: "10:30 · ✓✓"
        ))
        let incoming = FUIMessageBubble()
        incoming.configure(with: FUIMessageBubbleConfiguration(
            text: "All good, working on Melodify 🎵",
            variant: .incoming,
            meta: "10:31"
        ))
        stack.addArrangedSubview(outgoing)
        stack.addArrangedSubview(incoming)
        return stack
    }

    func makeAudioPlayerPreview() -> UIView {
        let player = FUIAudioPlayer()
        player.configure(with: FUIAudioPlayerConfiguration(
            duration: "0:42",
            isPlaying: false,
            variant: .incoming
        ))
        return player
    }

    func makePrimaryButtonPreview() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Spacing.md
        stack.alignment = .center
        let enabled = FUIPrimaryButton()
        enabled.configure(with: FUIPrimaryButtonConfiguration(title: "Play", isEnabled: true, isLoading: false))
        let disabled = FUIPrimaryButton()
        disabled.configure(with: FUIPrimaryButtonConfiguration(title: "Disabled", isEnabled: false, isLoading: false))
        let loading = FUIPrimaryButton()
        loading.configure(with: FUIPrimaryButtonConfiguration(title: "Loading", isEnabled: true, isLoading: true))
        [enabled, disabled, loading].forEach { stack.addArrangedSubview($0) }
        return stack
    }

    func makeTextFieldPreview() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spacing.md

        let normal = FUITextField()
        normal.configure(with: FUITextFieldConfiguration(
            label: "Email",
            placeholder: "you@example.com",
            iconName: "envelope"
        ))

        let error = FUITextField()
        error.configure(with: FUITextFieldConfiguration(
            label: "Password",
            placeholder: "Enter password",
            iconName: "lock",
            isSecure: true,
            errorText: "Too short"
        ))

        stack.addArrangedSubview(normal)
        stack.addArrangedSubview(error)
        return stack
    }

    func makeOtpFieldPreview() -> UIView {
        let otp = FUIOtpField()
        otp.configure(with: FUIOtpFieldConfiguration(length: 6))
        return otp
    }

    func makeListTilePreview() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spacing.xs

        let tile1 = FUIListTile()
        tile1.configure(with: FUIListTileConfiguration(
            title: "Notifications",
            subtitle: "Push and email",
            leadingIconName: FUIIcons.bell,
            showsChevron: true
        ))

        let tile2 = FUIListTile()
        tile2.configure(with: FUIListTileConfiguration(
            title: "Theme",
            trailingText: "Dark"
        ))

        stack.addArrangedSubview(tile1)
        stack.addArrangedSubview(tile2)
        return stack
    }

    func makePageControlPreview() -> UIView {
        let pc = FUIPageControl()
        pc.configure(with: FUIPageControlConfiguration(numberOfPages: 5, currentPage: 2))
        return pc
    }

    func makeAppBarPreview() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spacing.sm

        let textBar = FUIAppBar()
        textBar.configure(with: FUIAppBarConfiguration(
            variant: .text("Home"),
            trailingIconNames: [FUIIcons.search, FUIIcons.more]
        ))

        let backBar = FUIAppBar()
        backBar.configure(with: FUIAppBarConfiguration(
            variant: .text("Details"),
            showsBack: true,
            trailingIconNames: [FUIIcons.share]
        ))

        stack.addArrangedSubview(textBar)
        stack.addArrangedSubview(backBar)
        return stack
    }
}

// MARK: - SwiftUI Component Previews

private extension ForgeUICatalogViewController {
    func makeSUIButtonPreview() -> UIView {
        let view = HStack(spacing: 12) {
            Button("Filled")  {}.buttonStyle(FUIButtonStyle(variant: .filled))
            Button("Outlined"){}.buttonStyle(FUIButtonStyle(variant: .outlined))
        }.padding()
        return UIHostingView(rootView: view)
    }

    func makeSUIAvatarPreview() -> UIView {
        let view = HStack(spacing: 16) {
            FUIAvatar(name: "Taylor Swift", imageURL: nil, size: .small)
            FUIAvatar(name: "Taylor Swift", imageURL: nil, size: .medium)
            FUIAvatar(name: "Taylor Swift", imageURL: nil, size: .large)
        }.padding()
        return UIHostingView(rootView: view)
    }

    func makeSUIEmptyStatePreview() -> UIView {
        let view = FUIEmptyState(
            systemImageName: "waveform.slash",
            title: "No Messages",
            subtitle: "Start a conversation",
            actionTitle: "New Chat",
            action: {}
        ).padding()
        return UIHostingView(rootView: view)
    }

    func makeSUIBadgePreview() -> UIView {
        let view = HStack(spacing: 24) {
            Image(systemName: "bell.fill").mdsBadge(count: 0)
            Image(systemName: "bell.fill").mdsBadge(count: 3)
            Image(systemName: "bell.fill").mdsBadge(count: 99)
        }
        .font(.title2)
        .padding()
        return UIHostingView(rootView: view)
    }

    func makeSUILoadingOverlayPreview() -> UIView {
        let view = ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(FUIColor.surfaceElevated))
                .frame(height: 100)
            FUILoadingOverlay()
        }
        .frame(maxWidth: .infinity)
        .padding()
        return UIHostingView(rootView: view)
    }
}

// MARK: - Atoms (SwiftUI) Previews

private extension ForgeUICatalogViewController {

    func makeFUITextPreview() -> UIView {
        let view = VStack(alignment: .leading, spacing: Spacing.xs) {
            FUIText("Display", style: .display)
            FUIText("Title", style: .title)
            FUIText("Headline", style: .headline)
            FUIText("Body — the quick brown fox", style: .body)
            FUIText("Caption text", style: .caption)
            FUIText("Footnote text", style: .footnote)
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIIconPreview() -> UIView {
        let view = HStack(spacing: Spacing.lg) {
            VStack(spacing: Spacing.xs) {
                FUIIcon(FUIIcons.bell, size: .small)
                FUIText("sm", style: .caption)
            }
            VStack(spacing: Spacing.xs) {
                FUIIcon(FUIIcons.bell, size: .medium)
                FUIText("md", style: .caption)
            }
            VStack(spacing: Spacing.xs) {
                FUIIcon(FUIIcons.bell, size: .large)
                FUIText("lg", style: .caption)
            }
            VStack(spacing: Spacing.xs) {
                FUIIcon(FUIIcons.star, size: .medium, color: Color(FUIColor.warning))
                FUIText("tinted", style: .caption)
            }
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIIconButtonPreview() -> UIView {
        let view = HStack(spacing: Spacing.lg) {
            VStack(spacing: Spacing.xs) {
                FUIIconButton(icon: FUIIcons.heart, variant: .plain, action: {})
                FUIText("plain", style: .caption)
            }
            VStack(spacing: Spacing.xs) {
                FUIIconButton(icon: FUIIcons.heart, variant: .tonal, action: {})
                FUIText("tonal", style: .caption)
            }
            VStack(spacing: Spacing.xs) {
                FUIIconButton(icon: FUIIcons.heart, variant: .filled, action: {})
                FUIText("filled", style: .caption)
            }
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUITagPreview() -> UIView {
        let view = HStack(spacing: Spacing.sm) {
            FUITag("Neutral")
            FUITag("Info", status: .info)
            FUITag("Success", status: .success)
            FUITag("Warning", status: .warning)
            FUITag("Error", status: .error)
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIDividerPreview() -> UIView {
        let view = VStack(spacing: Spacing.sm) {
            FUIText("Above", style: .body)
            FUIDivider(axis: .horizontal)
            FUIText("Below", style: .body)
            HStack(spacing: Spacing.sm) {
                FUIText("Left", style: .body)
                FUIDivider(axis: .vertical).frame(height: 20)
                FUIText("Right", style: .body)
            }
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUICheckboxPreview() -> UIView {
        let view = _FUICheckboxDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIRadioPreview() -> UIView {
        let view = _FUIRadioDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUISwitchPreview() -> UIView {
        let view = _FUISwitchDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIShimmerPreview() -> UIView {
        let view = VStack(spacing: Spacing.sm) {
            FUIShimmer(height: 16, cornerRadius: Radius.sm)
                .frame(width: 200)
            FUIShimmer(height: 12, cornerRadius: Radius.xs)
                .frame(width: 140)
            FUIShimmer(width: 48, height: 48, cornerRadius: Radius.full)
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIProgressIndicatorPreview() -> UIView {
        let view = HStack(spacing: Spacing.xl) {
            VStack(spacing: Spacing.xs) {
                FUIProgressIndicator(variant: .circular)
                FUIText("indeterminate", style: .caption)
            }
            VStack(spacing: Spacing.xs) {
                FUIProgressIndicator(variant: .circular, progress: 0.65)
                FUIText("65%", style: .caption)
            }
            VStack(spacing: Spacing.xs) {
                FUIProgressIndicator(variant: .linear, progress: 0.4)
                    .frame(width: 100)
                FUIText("linear 40%", style: .caption)
            }
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUISliderPreview() -> UIView {
        let view = _FUISliderDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUITooltipPreview() -> UIView {
        let view = HStack(spacing: Spacing.lg) {
            FUIIcon(FUIIcons.info, size: .medium)
                .fuiTooltip("Tap for more info")
            FUIText("Hover me", style: .body)
                .fuiTooltip("Tooltip text here")
        }
        .padding(Spacing.md)
        return UIHostingView(rootView: view)
    }

    func makeFUIImagePreview() -> UIView {
        let view = HStack(spacing: Spacing.md) {
            FUIImage(url: nil, cornerRadius: Radius.md, aspectRatio: 1)
                .frame(width: 64, height: 64)
            FUIImage(url: nil, cornerRadius: Radius.full, aspectRatio: 1)
                .frame(width: 64, height: 64)
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIFabPreview() -> UIView {
        let view = HStack(spacing: Spacing.md) {
            FUIFab(icon: FUIIcons.add, variant: .primary, action: {})
            FUIFab(icon: FUIIcons.add, title: "New", variant: .primary, action: {})
            FUIFab(icon: FUIIcons.edit, variant: .surface, action: {})
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUISearchFieldPreview() -> UIView {
        let view = _FUISearchFieldDemo()
        return UIHostingView(rootView: view)
    }
}

// MARK: - Molecules (SwiftUI) Previews

private extension ForgeUICatalogViewController {

    func makeFUICardPreview() -> UIView {
        let view = FUICard(padding: Spacing.md) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                FUIText("Card Title", style: .headline)
                FUIText("Card body text goes here.", style: .body)
            }
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIBannerPreview() -> UIView {
        let view = VStack(spacing: Spacing.sm) {
            FUIBanner(message: "An info message.", status: .info, title: "FYI")
            FUIBanner(message: "Action completed.", status: .success)
            FUIBanner(message: "Check your input.", status: .warning, onDismiss: {})
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIChipPreview() -> UIView {
        let view = HStack(spacing: Spacing.sm) {
            FUIChip("Design")
            FUIChip("Swift", isSelected: true)
            FUIChip("iOS", isSelected: true, icon: FUIIcons.check)
            FUIChip("Remove", onRemove: {})
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUICheckboxListTilePreview() -> UIView {
        let view = _FUICheckboxListTileDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIRadioListTilePreview() -> UIView {
        let view = _FUIRadioListTileDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIToggleListTilePreview() -> UIView {
        let view = _FUIToggleListTileDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUISegmentedControlPreview() -> UIView {
        let view = _FUISegmentedControlDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUISelectPreview() -> UIView {
        let view = _FUISelectDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIStepperPreview() -> UIView {
        let view = _FUIStepperDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIToastPreview() -> UIView {
        let view = VStack(spacing: Spacing.sm) {
            FUIToast(message: "Saved successfully", status: .success)
            FUIToast(message: "Something went wrong", status: .error)
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUITimelinePreview() -> UIView {
        let items: [FUITimelineItem] = [
            FUITimelineItem(title: "Order placed", subtitle: "12:00 PM", status: .success),
            FUITimelineItem(title: "Processing", status: .info),
            FUITimelineItem(title: "Shipped", subtitle: "Pending", status: .neutral),
        ]
        let view = FUITimeline(items: items).padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIChatBubblePreview() -> UIView {
        let view = VStack(spacing: Spacing.xs) {
            FUIChatBubble(text: "Hello there!", variant: .outbound, meta: "10:30")
            FUIChatBubble(text: "Hey, how are you?", variant: .inbound, meta: "10:31")
        }
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIFileUploadPreview() -> UIView {
        let files = [
            FUIUploadFile(id: "1", name: "photo.jpg", progress: 1.0),
            FUIUploadFile(id: "2", name: "report.pdf", progress: 0.6),
        ]
        let view = FUIFileUpload(
            prompt: "Tap to upload",
            files: files,
            onTap: {},
            onRemove: { _ in }
        )
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }
}

// MARK: - Organisms (SwiftUI) Previews

private extension ForgeUICatalogViewController {

    func makeFUIDialogPreview() -> UIView {
        let view = FUIDialog(
            title: "Delete item?",
            message: "This action cannot be undone.",
            primaryTitle: "Delete",
            onPrimary: {},
            secondaryTitle: "Cancel",
            onSecondary: {}
        )
        .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUITabsPreview() -> UIView {
        let view = _FUITabsDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIAccordionPreview() -> UIView {
        let items = [
            FUIAccordionItem(id: "a", title: "What is ForgeUI?", detail: "A token-first Swift design system for UIKit and SwiftUI apps."),
            FUIAccordionItem(id: "b", title: "Does it support dark mode?", detail: "Yes — all colors are dynamic UIColor values."),
        ]
        let view = FUIAccordion(items: items).padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUIBottomNavBarPreview() -> UIView {
        let items = [
            FUIBottomNavItem(icon: FUIIcons.person, title: "Profile"),
            FUIBottomNavItem(icon: FUIIcons.search, title: "Discover"),
            FUIBottomNavItem(icon: FUIIcons.bell, title: "Inbox"),
            FUIBottomNavItem(icon: FUIIcons.settings, title: "Settings"),
        ]
        let view = _FUIBottomNavBarDemo(items: items)
        return UIHostingView(rootView: view)
    }

    func makeFUIBottomSheetPreview() -> UIView {
        let view = _FUIBottomSheetDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIContextMenuPreview() -> UIView {
        let actions = [
            FUIContextAction(title: "Edit", icon: FUIIcons.edit, isDestructive: false, handler: {}),
            FUIContextAction(title: "Share", icon: FUIIcons.share, isDestructive: false, handler: {}),
            FUIContextAction(title: "Delete", icon: FUIIcons.delete, isDestructive: true, handler: {}),
        ]
        let view = FUIText("Long-press me", style: .body)
            .padding(Spacing.md)
            .background(Color(FUIColor.surfaceElevated))
            .cornerRadius(Radius.md)
            .fuiContextMenu(actions)
            .padding(Spacing.sm)
        return UIHostingView(rootView: view)
    }

    func makeFUICalendarPreview() -> UIView {
        let view = _FUICalendarDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUICountryPickerPreview() -> UIView {
        let view = _FUICountryPickerDemo()
        return UIHostingView(rootView: view)
    }

    func makeFUIStoriesPreview() -> UIView {
        let view = _FUIStoriesDemo()
        return UIHostingView(rootView: view)
    }
}

// MARK: - Stateful SwiftUI Demo Wrappers

// Atoms
private struct _FUICheckboxDemo: View {
    @State private var checked = false
    var body: some View {
        HStack(spacing: Spacing.lg) {
            FUICheckbox(isChecked: checked, onChanged: { checked = $0 })
            FUICheckbox(isChecked: true, onChanged: { _ in })
            FUICheckbox(isChecked: false, isEnabled: false, onChanged: { _ in })
        }
        .padding(Spacing.sm)
    }
}

private struct _FUIRadioDemo: View {
    @State private var selection = "A"
    var body: some View {
        HStack(spacing: Spacing.lg) {
            ForEach(["A", "B", "C"], id: \.self) { val in
                HStack(spacing: Spacing.xs) {
                    FUIRadio(value: val, selection: selection, onSelect: { selection = $0 })
                    FUIText(val, style: .body)
                }
            }
        }
        .padding(Spacing.sm)
    }
}

private struct _FUISwitchDemo: View {
    @State private var isOn = true
    var body: some View {
        HStack(spacing: Spacing.lg) {
            FUISwitch(isOn: isOn, onChanged: { isOn = $0 })
            FUISwitch(isOn: false, isEnabled: false, onChanged: { _ in })
        }
        .padding(Spacing.sm)
    }
}

private struct _FUISliderDemo: View {
    @State private var value = 0.4
    var body: some View {
        VStack(spacing: Spacing.xs) {
            FUISlider(value: $value, range: 0...1, onChanged: { value = $0 })
                .frame(width: 220)
            FUIText(String(format: "%.2f", value), style: .caption)
        }
        .padding(Spacing.sm)
    }
}

private struct _FUISearchFieldDemo: View {
    @State private var text = ""
    var body: some View {
        FUISearchField(text: $text, placeholder: "Search songs…")
            .frame(width: 240)
            .padding(Spacing.sm)
    }
}

// Molecules
private struct _FUICheckboxListTileDemo: View {
    @State private var checked = false
    var body: some View {
        VStack(spacing: 0) {
            FUICheckboxListTile(
                title: "Notifications",
                subtitle: "Push and email",
                isChecked: checked,
                onChanged: { checked = $0 }
            )
            FUICheckboxListTile(
                title: "Marketing",
                isChecked: true,
                isEnabled: false,
                onChanged: { _ in }
            )
        }
        .padding(Spacing.sm)
    }
}

private struct _FUIRadioListTileDemo: View {
    @State private var selection = "Light"
    var body: some View {
        VStack(spacing: 0) {
            ForEach(["Light", "Dark", "System"], id: \.self) { theme in
                FUIRadioListTile(
                    title: theme,
                    value: theme,
                    selection: selection,
                    onSelect: { selection = $0 }
                )
            }
        }
        .padding(Spacing.sm)
    }
}

private struct _FUIToggleListTileDemo: View {
    @State private var isOn = true
    var body: some View {
        VStack(spacing: 0) {
            FUIToggleListTile(
                title: "Dark Mode",
                subtitle: "Use system appearance",
                isOn: isOn,
                onChanged: { isOn = $0 }
            )
            FUIToggleListTile(
                title: "Notifications",
                isOn: false,
                isEnabled: false,
                onChanged: { _ in }
            )
        }
        .padding(Spacing.sm)
    }
}

private struct _FUISegmentedControlDemo: View {
    @State private var index = 0
    var body: some View {
        VStack(spacing: Spacing.xs) {
            FUISegmentedControl(
                segments: ["Day", "Week", "Month"],
                selectedIndex: index,
                onChange: { index = $0 }
            )
            FUIText("Selected: \(["Day","Week","Month"][index])", style: .caption)
        }
        .padding(Spacing.sm)
    }
}

private struct _FUISelectDemo: View {
    @State private var selected: String? = nil
    let options = ["Design", "Engineering", "Product", "Marketing"]
    var body: some View {
        FUISelect(
            title: "Team",
            options: options,
            selection: selected,
            optionLabel: { $0 },
            placeholder: "Choose a team",
            onSelect: { selected = $0 }
        )
        .padding(Spacing.sm)
    }
}

private struct _FUIStepperDemo: View {
    @State private var count = 1
    var body: some View {
        HStack(spacing: Spacing.md) {
            FUIStepper(value: count, range: 0...10, onChanged: { count = $0 })
            FUIText("Qty: \(count)", style: .body)
        }
        .padding(Spacing.sm)
    }
}

// Organisms
private struct _FUITabsDemo: View {
    @State private var selection = 0
    var body: some View {
        FUITabs(
            tabs: [
                FUITab(title: "Home", view: AnyView(FUIText("Home content", style: .body).padding())),
                FUITab(title: "Profile", view: AnyView(FUIText("Profile content", style: .body).padding())),
                FUITab(title: "Settings", view: AnyView(FUIText("Settings content", style: .body).padding())),
            ],
            selection: $selection
        )
        .frame(height: 180)
        .padding(Spacing.sm)
    }
}

private struct _FUIBottomNavBarDemo: View {
    let items: [FUIBottomNavItem]
    @State private var selectedIndex = 0
    var body: some View {
        FUIBottomNavBar(items: items, selectedIndex: selectedIndex, onSelect: { selectedIndex = $0 })
    }
}

private struct _FUIBottomSheetDemo: View {
    @State private var isPresented = false
    var body: some View {
        Button("Show Bottom Sheet") { isPresented = true }
            .buttonStyle(FUIButtonStyle(variant: .outlined))
            .padding(Spacing.sm)
            .fuiBottomSheet(isPresented: $isPresented, detents: [.medium]) {
                VStack(spacing: Spacing.md) {
                    FUIBottomSheetHandle()
                    FUIText("Bottom Sheet Content", style: .headline)
                    FUIText("Swipe down to dismiss.", style: .body)
                    Spacer()
                }
                .padding(Spacing.md)
            }
    }
}

private struct _FUICalendarDemo: View {
    @State private var selectedDate = Date()
    var body: some View {
        FUICalendar(selectedDate: selectedDate, onSelect: { selectedDate = $0 })
            .padding(Spacing.sm)
    }
}

private struct _FUICountryPickerDemo: View {
    @State private var isPresented = false
    @State private var selectedCountry: FUICountry? = nil
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Button(selectedCountry.map { "\($0.dialCode) \($0.name)" } ?? "Pick country") {
                isPresented = true
            }
            .buttonStyle(FUIButtonStyle(variant: .outlined))
        }
        .padding(Spacing.sm)
        .fuiCountryPicker(isPresented: $isPresented, onSelect: { selectedCountry = $0 })
    }
}

private struct _FUIStoriesDemo: View {
    @State private var isPresented = false
    let storyItems = [
        FUIStoryItem(id: "1", content: AnyView(
            ZStack {
                Color(FUIColor.primary)
                FUIText("Story 1", style: .title, color: .white)
            }
        )),
        FUIStoryItem(id: "2", content: AnyView(
            ZStack {
                Color(FUIColor.success)
                FUIText("Story 2", style: .title, color: .white)
            }
        )),
    ]
    var body: some View {
        Button("Launch Stories") { isPresented = true }
            .buttonStyle(FUIButtonStyle(variant: .filled))
            .padding(Spacing.sm)
            .fullScreenCover(isPresented: $isPresented) {
                FUIStories(items: storyItems, onFinish: { isPresented = false })
            }
    }
}

// MARK: - CatalogCell

private final class CatalogCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let previewContainer = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        nameLabel.font = Typography.title
        nameLabel.textColor = FUIColor.textPrimary
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        previewContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nameLabel)
        contentView.addSubview(previewContainer)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.md),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.md),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.md),

            previewContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Spacing.sm),
            previewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.md),
            previewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.md),
            previewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.md),
        ])
    }

    required init?(coder: NSCoder) { nil }

    func configure(title: String, preview: UIView) {
        nameLabel.text = title
        preview.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(preview)
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: previewContainer.topAnchor),
            preview.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor),
            preview.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor),
            // trailing is `lessThanOrEqualTo` so intrinsic-width previews (stacks) don't stretch
            preview.trailingAnchor.constraint(lessThanOrEqualTo: previewContainer.trailingAnchor),
        ])
    }
}
