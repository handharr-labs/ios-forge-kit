import SwiftUI

/// An inline status message bar with a leading status symbol, optional title,
/// body message, and optional dismiss button.
public struct FUIBanner: View {
    public let message: String
    public let status: FUIStatus
    public let title: String?
    public let onDismiss: (() -> Void)?

    public init(
        message: String,
        status: FUIStatus = .info,
        title: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.status = status
        self.title = title
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: status.symbolName)
                .foregroundColor(status.swiftUIOnFill)
                .font(.fuiBody)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                if let title {
                    Text(title)
                        .font(.fuiLabel)
                        .foregroundColor(status.swiftUIOnFill)
                }
                Text(message)
                    .font(.fuiBody)
                    .foregroundColor(status.swiftUIOnFill)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: FUIIcons.close)
                        .foregroundColor(status.swiftUIOnFill)
                        .font(.fuiBody)
                        .padding(.top, 1)  // match the leading icon so the × aligns with it
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(status.swiftUIFill)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
    }
}
