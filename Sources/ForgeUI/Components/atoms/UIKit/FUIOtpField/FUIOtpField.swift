import UIKit

/// A fixed-length OTP / PIN entry composed of N visible cells backed by a single
/// hidden `UITextField`. Paste, backspace, and platform auto-advance all come from
/// the system field for free; the visible cells are purely decorative overlays.
///
/// The active cell (index == text.count) receives a primary-color border.
/// Tapping anywhere on the view focuses the hidden field.
public final class FUIOtpField: UIView {

    // MARK: - Private state

    private var length: Int = 6
    private var cellViews: [_OTPCellView] = []

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = Spacing.sm
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let hiddenField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.isHidden = true   // visually invisible; receives focus normally
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // MARK: - Public callbacks

    /// Fires on every character change.
    public var onChanged: ((String) -> Void)?
    /// Fires once all cells are filled.
    public var onCompleted: ((String) -> Void)?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        hiddenField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        // Focus on tap anywhere
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponderIfNeeded))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    public func configure(with config: FUIOtpFieldConfiguration) {
        length = max(1, config.length)
        hiddenField.text = ""

        // Rebuild cells
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        cellViews = (0..<length).map { _ in _OTPCellView() }
        cellViews.forEach { stackView.addArrangedSubview($0) }

        refreshCells()
    }

    // MARK: - First responder forwarding

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        hiddenField.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        hiddenField.resignFirstResponder()
    }

    // MARK: - Private

    @objc private func becomeFirstResponderIfNeeded() {
        hiddenField.becomeFirstResponder()
    }

    @objc private func textDidChange() {
        var text = hiddenField.text ?? ""
        // Clamp to length
        if text.count > length {
            text = String(text.prefix(length))
            hiddenField.text = text
        }
        refreshCells()
        onChanged?(text)
        if text.count == length {
            onCompleted?(text)
        }
    }

    private func refreshCells() {
        let text = hiddenField.text ?? ""
        let focused = hiddenField.isFirstResponder
        for (i, cell) in cellViews.enumerated() {
            let char = i < text.count ? String(text[text.index(text.startIndex, offsetBy: i)]) : ""
            let isActive = focused && i == text.count
            cell.update(char: char, isActive: isActive)
        }
    }

    private func setupLayout() {
        addSubview(hiddenField)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            hiddenField.widthAnchor.constraint(equalToConstant: 0),
            hiddenField.heightAnchor.constraint(equalToConstant: 0),
            hiddenField.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: - Cell

private final class _OTPCellView: UIView {
    private let digitLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.title
        l.textColor = FUIColor.textPrimary
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = FUIColor.surfaceVariant
        layer.cornerRadius = Radius.md
        layer.borderWidth = 1
        layer.borderColor = FUIColor.line.cgColor
        addSubview(digitLabel)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 44),
            heightAnchor.constraint(equalToConstant: 52),
            digitLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            digitLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func update(char: String, isActive: Bool) {
        digitLabel.text = char
        layer.borderColor = isActive
            ? FUIColor.primary.cgColor
            : FUIColor.line.cgColor
        layer.borderWidth = isActive ? 1.5 : 1
    }
}
