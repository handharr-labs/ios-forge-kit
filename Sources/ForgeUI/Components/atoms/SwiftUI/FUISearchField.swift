import SwiftUI

/// Pill search input.
///
/// Renders its own chrome: `FUIColor.surfaceVariant` pill background, a leading
/// magnifying-glass icon (`FUIIcons.search`), and an inline clear button
/// (`FUIIcons.clear`) that appears when the field is non-empty. This is a
/// standalone component, not a restyle of `searchable` or `TextField` bare metal.
public struct FUISearchField: View {
    @Binding private var text: String
    public let placeholder: String

    @FocusState private var isFocused: Bool

    public init(text: Binding<String>, placeholder: String = "Search") {
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: FUIIcons.search)
                .foregroundColor(Color(FUIColor.textSecondary))
                .font(.system(size: 16))

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.fuiBody)
                        .foregroundColor(Color(FUIColor.textDisabled))
                }
                TextField("", text: $text)
                    .font(.fuiBody)
                    .foregroundColor(Color(FUIColor.textPrimary))
                    .focused($isFocused)
                    .submitLabel(.search)
            }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: FUIIcons.clear)
                        .foregroundColor(Color(FUIColor.textSecondary))
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm + 2)
        .background(Color(FUIColor.surfaceVariant))
        .clipShape(Capsule())
    }
}
