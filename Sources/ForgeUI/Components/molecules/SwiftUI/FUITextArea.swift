import SwiftUI

/// A multi-line text editor in token styling: it wraps `TextEditor`, shows a
/// placeholder while empty, and, when `characterLimit` is set, a "n / limit"
/// counter that turns `FUIColor.warning` once the text is over the limit.
/// The limit is advisory: typing is never blocked, so callers validate.
public struct FUITextArea: View {
    @Binding private var text: String
    public let placeholder: String?
    public let minLines: Int
    public let characterLimit: Int?
    public let isMonospaced: Bool

    public init(
        text: Binding<String>,
        placeholder: String? = nil,
        minLines: Int = 4,
        characterLimit: Int? = nil,
        isMonospaced: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.minLines = max(1, minLines)
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

    var editorFont: Font {
        isMonospaced ? .system(size: 13, weight: .regular, design: .monospaced) : .fuiBody
    }

    /// Height that fits `minLines` lines of the editor font plus padding.
    var minHeight: CGFloat {
        let font: PlatformFont = isMonospaced
            ? .monospacedSystemFont(ofSize: 13, weight: .regular)
            : Typography.body
        return Self.lineHeight(of: font) * CGFloat(minLines) + Spacing.sm * 2
    }

    static func lineHeight(of font: PlatformFont) -> CGFloat {
        #if canImport(UIKit)
        return font.lineHeight.rounded(.up)
        #else
        return (font.ascender - font.descender + font.leading).rounded(.up)
        #endif
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .trailing, spacing: Spacing.xs) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(editorFont)
                    .foregroundColor(Color(FUIColor.textPrimary))
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, Spacing.xs)
                    .padding(.vertical, Spacing.sm - Spacing.xs)
                if showsPlaceholder, let placeholder {
                    Text(placeholder)
                        .font(editorFont)
                        .foregroundColor(Color(FUIColor.textDisabled))
                        .padding(.horizontal, Spacing.xs + 5)
                        .padding(.vertical, Spacing.sm)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: minHeight)
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
