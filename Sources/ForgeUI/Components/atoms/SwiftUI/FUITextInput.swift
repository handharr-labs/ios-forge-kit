import SwiftUI

/// A single-line text input in token styling: it wraps `TextField`, shows a placeholder while
/// empty, and, when `characterLimit` is set, a "n / limit" counter that turns `FUIColor.warning`
/// once the text is over the limit. The limit is advisory: typing is never blocked, so callers
/// validate.
public struct FUITextInput: View {
    @Binding private var text: String
    public let placeholder: String?
    public let characterLimit: Int?
    public let isMonospaced: Bool

    public init(
        text: Binding<String>,
        placeholder: String? = nil,
        characterLimit: Int? = nil,
        isMonospaced: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
        self.isMonospaced = isMonospaced
    }

    // MARK: - Derived state (internal for tests)

    /// True when a limit is set and the text is longer than it.
    var isOverLimit: Bool {
        guard let characterLimit else { return false }
        return text.count > characterLimit
    }

    /// "n / limit", or nil when there is no limit.
    var counterText: String? {
        guard let characterLimit else { return nil }
        return "\(text.count) / \(characterLimit)"
    }

    /// Whether the placeholder is visible: it has text and the field is empty.
    var showsPlaceholder: Bool {
        guard let placeholder else { return false }
        return !placeholder.isEmpty && text.isEmpty
    }

    var inputFont: Font {
        isMonospaced ? .system(size: 13, weight: .regular, design: .monospaced) : .fuiBody
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .trailing, spacing: Spacing.xs) {
            ZStack(alignment: .leading) {
                if showsPlaceholder, let placeholder {
                    Text(placeholder)
                        .font(inputFont)
                        .foregroundColor(Color(FUIColor.textDisabled))
                        .allowsHitTesting(false)
                }
                TextField("", text: $text)
                    .textFieldStyle(.plain)
                    .font(inputFont)
                    .foregroundColor(Color(FUIColor.textPrimary))
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.sm)
            .background(Color(FUIColor.surfaceVariant))
            .cornerRadius(Radius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Color(isOverLimit ? FUIColor.warning : FUIColor.line), lineWidth: 1)
            )

            if let counterText {
                Text(counterText)
                    .font(.fuiCaption)
                    .foregroundColor(Color(isOverLimit ? FUIColor.warning : FUIColor.textSecondary))
            }
        }
    }
}
