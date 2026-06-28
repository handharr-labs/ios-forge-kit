import SwiftUI

/// A dropdown selector backed by SwiftUI `Menu`. Displays the current selection
/// label (or a placeholder) with a trailing chevron. Fires `onSelect` when the
/// user picks an option.
public struct FUISelect<Value: Hashable>: View {
    public let title: String
    public let options: [Value]
    public let selection: Value?
    public let optionLabel: (Value) -> String
    public let placeholder: String
    public let onSelect: (Value) -> Void

    public init(
        title: String,
        options: [Value],
        selection: Value?,
        optionLabel: @escaping (Value) -> String,
        placeholder: String = "Select",
        onSelect: @escaping (Value) -> Void
    ) {
        self.title = title
        self.options = options
        self.selection = selection
        self.optionLabel = optionLabel
        self.placeholder = placeholder
        self.onSelect = onSelect
    }

    private var currentLabel: String {
        selection.map { optionLabel($0) } ?? placeholder
    }

    private var hasSelection: Bool { selection != nil }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(.fuiCaption)
                .foregroundColor(Color(FUIColor.textSecondary))

            Menu {
                ForEach(options, id: \.self) { option in
                    Button(optionLabel(option)) {
                        onSelect(option)
                    }
                }
            } label: {
                HStack {
                    Text(currentLabel)
                        .font(.fuiBody)
                        .foregroundColor(
                            hasSelection
                                ? Color(FUIColor.textPrimary)
                                : Color(FUIColor.textSecondary)
                        )
                    Spacer()
                    Image(systemName: FUIIcons.chevronDown)
                        .font(.fuiCaption)
                        .foregroundColor(Color(FUIColor.onSurfaceVariant))
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(Color(FUIColor.surfaceVariant))
                .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                        .stroke(Color(FUIColor.line), lineWidth: 1)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
