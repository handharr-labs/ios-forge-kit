import UIKit

public final class FUIMessageBubble: UIView {
    private let textLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = Typography.body
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let metaLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Radius.lg
        addSubview(textLabel)
        addSubview(metaLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.sm + 2),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.md - 4),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Spacing.md - 4)),

            metaLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Spacing.xs),
            metaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Spacing.md - 4)),
            metaLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.sm)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func configure(with config: FUIMessageBubbleConfiguration) {
        textLabel.text = config.text
        metaLabel.text = config.meta

        switch config.variant {
        case .outgoing:
            backgroundColor       = FUIColor.primary
            textLabel.textColor   = FUIColor.onPrimary
            metaLabel.textColor   = FUIColor.onPrimary.withAlphaComponent(0.7)
        case .incoming:
            backgroundColor       = FUIColor.surfaceElevated
            textLabel.textColor   = FUIColor.textPrimary
            metaLabel.textColor   = FUIColor.textDisabled
        }
    }
}
