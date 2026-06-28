import UIKit

/// A top app bar with three variants: `.text`, `.logo`, and `.search`.
///
/// - `.text(title)` — title label on the leading edge, optional back button,
///   optional trailing icon buttons.
/// - `.logo(image)` — brand image replaces the title area.
/// - `.search(placeholder)` — an inline rounded search field replaces the title.
///
/// Background: `FUIColor.surface`. Bottom edge: 1 pt hairline (`FUIColor.line`).
/// Height is fixed at 56 pt (matching the Flutter reference).
public final class FUIAppBar: UIView {

    // MARK: - Constants

    private static let barHeight: CGFloat = 56

    // MARK: - Sub-views

    private let backButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: FUIIcons.back)
        config.baseForegroundColor = FUIColor.textPrimary
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    // Center — one of these three is visible at a time
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.headline
        l.textColor = FUIColor.textPrimary
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let searchField: UITextField = {
        let tf = UITextField()
        tf.font = Typography.body
        tf.textColor = FUIColor.textPrimary
        tf.backgroundColor = FUIColor.surfaceVariant
        tf.borderStyle = .none
        tf.layer.cornerRadius = Radius.full
        tf.layer.masksToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false

        // Leading search icon
        let icon = UIImageView(image: UIImage(systemName: FUIIcons.search))
        icon.tintColor = FUIColor.textSecondary
        icon.contentMode = .center
        icon.frame = CGRect(x: 0, y: 0, width: 36, height: 20)
        tf.leftView = icon
        tf.leftViewMode = .always
        return tf
    }()

    // Trailing icon buttons container
    private let trailingStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = Spacing.xs
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let hairline: UIView = {
        let v = UIView()
        v.backgroundColor = FUIColor.line
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Callbacks

    /// Fired when the back button is tapped.
    public var onBack: (() -> Void)?
    /// Fired when a trailing icon button is tapped; receives the button's index.
    public var onTrailingTap: ((Int) -> Void)?
    /// Fired on search text changes (`.search` variant only).
    public var onSearchTextChanged: ((String) -> Void)?

    // MARK: - Layout helpers

    private var centerLeadingToBackTrailing: NSLayoutConstraint!
    private var centerLeadingToSafeArea: NSLayoutConstraint!

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = FUIColor.surface
        setupLayout()
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        searchField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    public func configure(with config: FUIAppBarConfiguration) {
        // Back button
        backButton.isHidden = !config.showsBack
        centerLeadingToBackTrailing.isActive = config.showsBack
        centerLeadingToSafeArea.isActive = !config.showsBack

        // Center content
        titleLabel.isHidden = true
        logoImageView.isHidden = true
        searchField.isHidden = true

        switch config.variant {
        case .text(let title):
            titleLabel.text = title
            titleLabel.isHidden = false
        case .logo(let image):
            logoImageView.image = image
            logoImageView.isHidden = false
        case .search(let placeholder):
            searchField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor: FUIColor.textSecondary,
                    .font: Typography.body
                ]
            )
            searchField.isHidden = false
        }

        // Trailing buttons — rebuild
        trailingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, name) in config.trailingIconNames.enumerated() {
            let btn = _iconButton(systemName: name, tag: index)
            trailingStack.addArrangedSubview(btn)
        }
    }

    // MARK: - Actions

    @objc private func backTapped() {
        onBack?()
    }

    @objc private func trailingButtonTapped(_ sender: UIButton) {
        onTrailingTap?(sender.tag)
    }

    @objc private func searchTextChanged() {
        onSearchTextChanged?(searchField.text ?? "")
    }

    // MARK: - Helpers

    private func _iconButton(systemName: String, tag: Int) -> UIButton {
        var cfg = UIButton.Configuration.plain()
        cfg.image = UIImage(systemName: systemName)
        cfg.baseForegroundColor = FUIColor.textPrimary
        let b = UIButton(configuration: cfg)
        b.tag = tag
        b.addTarget(self, action: #selector(trailingButtonTapped(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            b.widthAnchor.constraint(equalToConstant: 40),
            b.heightAnchor.constraint(equalToConstant: FUIAppBar.barHeight)
        ])
        return b
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(logoImageView)
        addSubview(searchField)
        addSubview(trailingStack)
        addSubview(hairline)

        // Back button sizing
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: FUIAppBar.barHeight),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.sm),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            heightAnchor.constraint(equalToConstant: FUIAppBar.barHeight)
        ])

        // Center constraints (two alternatives, toggled in configure)
        centerLeadingToBackTrailing = titleLabel.leadingAnchor.constraint(
            equalTo: backButton.trailingAnchor, constant: Spacing.xs)
        centerLeadingToSafeArea = titleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor, constant: Spacing.md)

        // Title label
        NSLayoutConstraint.activate([
            centerLeadingToBackTrailing,  // default; toggled in configure
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingStack.leadingAnchor, constant: -Spacing.xs)
        ])

        // Logo image — same anchors via same leading anchors
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 32),
            logoImageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingStack.leadingAnchor, constant: -Spacing.xs)
        ])

        // Search field — same leading anchor
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchField.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.trailingAnchor.constraint(equalTo: trailingStack.leadingAnchor, constant: -Spacing.xs)
        ])

        // Trailing stack
        NSLayoutConstraint.activate([
            trailingStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.sm),
            trailingStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Hairline
        NSLayoutConstraint.activate([
            hairline.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairline.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairline.bottomAnchor.constraint(equalTo: bottomAnchor),
            hairline.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }
}
