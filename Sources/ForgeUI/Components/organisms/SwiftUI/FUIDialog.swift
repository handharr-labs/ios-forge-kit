import SwiftUI

/// A centered alert-style dialog card with a title, message, and up to two
/// actions. Present it via the `.fuiDialog(isPresented:...)` View extension,
/// which dims the background and centers the card over the current content.
public struct FUIDialog: View {
    public let title: String
    public let message: String
    public let primaryTitle: String
    public let onPrimary: () -> Void
    public let secondaryTitle: String?
    public let onSecondary: (() -> Void)?

    public init(
        title: String,
        message: String,
        primaryTitle: String,
        onPrimary: @escaping () -> Void,
        secondaryTitle: String? = nil,
        onSecondary: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryTitle = primaryTitle
        self.onPrimary = onPrimary
        self.secondaryTitle = secondaryTitle
        self.onSecondary = onSecondary
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .font(.fuiHeadline)
                .foregroundColor(Color(FUIColor.textPrimary))

            Text(message)
                .font(.fuiBody)
                .foregroundColor(Color(FUIColor.textSecondary))

            HStack(spacing: Spacing.sm) {
                Spacer()
                if let secondaryTitle {
                    Button(secondaryTitle) { onSecondary?() }
                        .font(.fuiLabel)
                        .foregroundColor(Color(FUIColor.primary))
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.sm)
                }
                Button(primaryTitle, action: onPrimary)
                    .font(.fuiLabel)
                    .foregroundColor(Color(FUIColor.onPrimary))
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.sm)
                    .background(Color(FUIColor.primary))
                    .cornerRadius(Radius.sm)
            }
            .padding(.top, Spacing.sm)
        }
        .padding(Spacing.lg)
        .frame(maxWidth: 360)
        .background(Color(FUIColor.surface))
        .cornerRadius(Radius.lg)
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 4)
        .padding(.horizontal, Spacing.xl)
    }
}

// MARK: - ViewModifier

private struct FUIDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let primaryTitle: String
    let onPrimary: () -> Void
    let secondaryTitle: String?
    let onSecondary: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                FUIDialog(
                    title: title,
                    message: message,
                    primaryTitle: primaryTitle,
                    onPrimary: {
                        isPresented = false
                        onPrimary()
                    },
                    secondaryTitle: secondaryTitle,
                    onSecondary: secondaryTitle != nil ? {
                        isPresented = false
                        onSecondary?()
                    } : nil
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .animation(.easeOut(duration: 0.18), value: isPresented)
            }
        }
    }
}

public extension View {
    /// Overlays a `FUIDialog` centered on the receiver with a dimmed background.
    func fuiDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryTitle: String,
        onPrimary: @escaping () -> Void,
        secondaryTitle: String? = nil,
        onSecondary: (() -> Void)? = nil
    ) -> some View {
        modifier(FUIDialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryTitle: primaryTitle,
            onPrimary: onPrimary,
            secondaryTitle: secondaryTitle,
            onSecondary: onSecondary
        ))
    }
}
