import UIKit

public final class FUILoading: UIView {
    private let spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(style: .medium)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.startAnimating()
        return s
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.caption
        l.textColor = FUIColor.textSecondary
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [spinner, messageLabel])
        stack.axis = .vertical
        stack.spacing = Spacing.sm
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Spacing.md),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Spacing.md),
            // Vertical hug so the inline variant has an intrinsic height (otherwise the
            // view collapses to 0pt in a self-sizing container and the spinner overlaps the label).
            stack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Spacing.md),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Spacing.md)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func configure(with config: FUILoadingConfiguration) {
        messageLabel.text = config.message
        messageLabel.isHidden = config.message == nil
        backgroundColor = config.variant == .fullscreen
            ? FUIColor.surface.withAlphaComponent(0.8)
            : .clear
    }
}
