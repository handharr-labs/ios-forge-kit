import UIKit

/// A token-styled text input with an optional leading label, placeholder,
/// leading icon, secure-entry mode, and an inline error message + red border
/// when `configuration.errorText` is non-nil.
///
/// Layout: vertical stack — label (optional) → surfaceVariant well → error label (optional).
/// The well contains an optional SF-Symbol icon, the `UITextField`, and a
/// clear / secure-toggle button area managed by the field itself.
public final class FUITextField: UIView {

    // MARK: - Sub-views

    private let labelView: UILabel = {
        let l = UILabel()
        l.font = Typography.label
        l.textColor = FUIColor.textPrimary
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let wellView: UIView = {
        let v = UIView()
        v.backgroundColor = FUIColor.surfaceVariant
        v.layer.cornerRadius = Radius.md
        v.layer.borderWidth = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = FUIColor.textSecondary
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.font = Typography.body
        tf.textColor = FUIColor.textPrimary
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.footnote
        l.textColor = FUIColor.error
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Constraints toggled by icon visibility

    private var iconWidthConstraint: NSLayoutConstraint!
    private var iconTrailingToFieldLeading: NSLayoutConstraint!

    // MARK: - Public callback

    /// Fired on every character change; receives the current text.
    public var onTextChanged: ((String) -> Void)?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    public func configure(with config: FUITextFieldConfiguration) {
        // Label
        if let label = config.label {
            labelView.text = label
            labelView.isHidden = false
        } else {
            labelView.isHidden = true
        }

        // Placeholder
        if let placeholder = config.placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor: FUIColor.textSecondary,
                    .font: Typography.body
                ]
            )
        } else {
            textField.attributedPlaceholder = nil
        }

        // Text
        textField.text = config.text

        // Secure
        textField.isSecureTextEntry = config.isSecure

        // Icon
        if let iconName = config.iconName,
           let image = UIImage(systemName: iconName) {
            iconView.image = image
            iconView.isHidden = false
            iconWidthConstraint.constant = 20
            iconTrailingToFieldLeading.constant = Spacing.sm
        } else {
            iconView.isHidden = true
            iconWidthConstraint.constant = 0
            iconTrailingToFieldLeading.constant = 0
        }

        // Error
        let hasError = config.errorText != nil
        if let errorText = config.errorText {
            errorLabel.text = errorText
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
        wellView.layer.borderColor = hasError
            ? FUIColor.error.cgColor
            : FUIColor.line.cgColor
    }

    // MARK: - Actions

    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(labelView)
        addSubview(wellView)
        wellView.addSubview(iconView)
        wellView.addSubview(textField)
        addSubview(errorLabel)

        // Default border
        wellView.layer.borderColor = FUIColor.line.cgColor

        iconWidthConstraint = iconView.widthAnchor.constraint(equalToConstant: 0)
        // textField sits to the *right* of the icon: text.leading = icon.trailing + gap.
        iconTrailingToFieldLeading = textField.leadingAnchor.constraint(
            equalTo: iconView.trailingAnchor, constant: 0)

        NSLayoutConstraint.activate([
            // Label
            labelView.topAnchor.constraint(equalTo: topAnchor),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Well below label
            wellView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: Spacing.xs),
            wellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wellView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Icon inside well
            iconView.leadingAnchor.constraint(equalTo: wellView.leadingAnchor, constant: Spacing.md),
            iconView.centerYAnchor.constraint(equalTo: wellView.centerYAnchor),
            iconWidthConstraint,
            iconView.heightAnchor.constraint(equalToConstant: 20),

            // TextField inside well
            iconTrailingToFieldLeading,
            textField.topAnchor.constraint(equalTo: wellView.topAnchor, constant: Spacing.md),
            textField.bottomAnchor.constraint(equalTo: wellView.bottomAnchor, constant: -Spacing.md),
            textField.trailingAnchor.constraint(equalTo: wellView.trailingAnchor, constant: -Spacing.md),
            textField.leadingAnchor.constraint(greaterThanOrEqualTo: wellView.leadingAnchor, constant: Spacing.md),

            // Error label below well
            errorLabel.topAnchor.constraint(equalTo: wellView.bottomAnchor, constant: Spacing.xs),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
