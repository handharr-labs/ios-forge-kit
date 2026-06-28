import UIKit

/// A single-row list item: optional leading icon, title + optional subtitle,
/// optional trailing text or chevron. Calls `onTap` when tapped.
///
/// Intended to be embedded in a `UITableView` cell's content view or used
/// standalone as a tappable row.
public final class FUIListTile: UIView {

    // MARK: - Sub-views

    private let leadingIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = FUIColor.textSecondary
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.body
        l.textColor = FUIColor.textPrimary
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.caption
        l.textColor = FUIColor.textSecondary
        l.numberOfLines = 2
        l.lineBreakMode = .byTruncatingTail
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let trailingTextLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.caption
        l.textColor = FUIColor.textSecondary
        l.translatesAutoresizingMaskIntoConstraints = false
        l.setContentHuggingPriority(.required, for: .horizontal)
        l.setContentCompressionResistancePriority(.required, for: .horizontal)
        return l
    }()

    private let chevronView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: FUIIcons.chevronRight)
        iv.tintColor = FUIColor.textSecondary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Layout constraints toggled per config

    private var leadingIconWidthConstraint: NSLayoutConstraint!
    private var leadingIconToTextLeading: NSLayoutConstraint!

    // MARK: - Callback

    /// Called when the tile is tapped (only when set).
    public var onTap: (() -> Void)?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    public func configure(with config: FUIListTileConfiguration) {
        // Title
        titleLabel.text = config.title

        // Subtitle
        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle == nil

        // Leading icon
        if let name = config.leadingIconName,
           let image = UIImage(systemName: name) {
            leadingIconView.image = image
            leadingIconView.isHidden = false
            leadingIconWidthConstraint.constant = 24
            leadingIconToTextLeading.constant = Spacing.md
        } else {
            leadingIconView.isHidden = true
            leadingIconWidthConstraint.constant = 0
            leadingIconToTextLeading.constant = 0
        }

        // Trailing
        if let text = config.trailingText {
            trailingTextLabel.text = text
            trailingTextLabel.isHidden = false
            chevronView.isHidden = true
        } else if config.showsChevron {
            chevronView.isHidden = false
            trailingTextLabel.isHidden = true
        } else {
            trailingTextLabel.isHidden = true
            chevronView.isHidden = true
        }
    }

    // MARK: - Actions

    @objc private func handleTap() {
        onTap?()
    }

    // MARK: - Layout

    private func setupLayout() {
        // Text stack
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = Spacing.xs
        textStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(leadingIconView)
        addSubview(textStack)
        addSubview(trailingTextLabel)
        addSubview(chevronView)

        leadingIconWidthConstraint = leadingIconView.widthAnchor.constraint(equalToConstant: 0)
        leadingIconToTextLeading = leadingIconView.trailingAnchor.constraint(
            equalTo: textStack.leadingAnchor, constant: 0)

        NSLayoutConstraint.activate([
            // Leading icon
            leadingIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.lg),
            leadingIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingIconWidthConstraint,
            leadingIconView.heightAnchor.constraint(equalToConstant: 24),

            // Text stack
            leadingIconToTextLeading,
            textStack.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.md),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.md),
            textStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Spacing.lg),

            // Trailing text
            trailingTextLabel.leadingAnchor.constraint(equalTo: textStack.trailingAnchor, constant: Spacing.md),
            trailingTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.lg),

            // Chevron
            chevronView.leadingAnchor.constraint(equalTo: textStack.trailingAnchor, constant: Spacing.md),
            chevronView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.lg),
            chevronView.widthAnchor.constraint(equalToConstant: 16),
            chevronView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
