import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A sheet for reading long text: a title with an optional subtitle, the text
/// in a scrollable, selectable, wrapped body, and Copy / Close buttons.
/// Copy briefly switches its label to "Copied". The full text is always
/// rendered; nothing is truncated. Present it via the
/// `.fuiTextSheet(item:title:subtitle:text:)` View extension.
public struct FUITextSheet: View {
    public let title: String
    public let subtitle: String?
    public let text: String
    public let onClose: () -> Void

    @State private var didCopy = false

    public init(
        title: String,
        subtitle: String? = nil,
        text: String,
        onClose: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.text = text
        self.onClose = onClose
    }

    /// Label of the Copy button: "Copied" while the confirmation shows.
    var copyLabel: String { didCopy ? "Copied" : "Copy" }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(.fuiHeadline)
                    .foregroundColor(Color(FUIColor.textPrimary))
                if let subtitle {
                    Text(subtitle)
                        .font(.fuiCaption)
                        .foregroundColor(Color(FUIColor.textSecondary))
                }
            }

            ScrollView {
                Text(text)
                    .font(.fuiBody)
                    .foregroundColor(Color(FUIColor.textPrimary))
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.sm)
            }
            .background(Color(FUIColor.surface))
            .cornerRadius(Radius.sm)

            HStack(spacing: Spacing.sm) {
                Spacer()
                Button(action: copy) {
                    Label(copyLabel, systemImage: didCopy ? FUIIcons.check : FUIIcons.copy)
                        .font(.fuiLabel)
                        .foregroundColor(Color(FUIColor.primary))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)

                Button(action: onClose) {
                    Label("Close", systemImage: FUIIcons.close)
                        .font(.fuiLabel)
                        .foregroundColor(Color(FUIColor.onPrimary))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(Color(FUIColor.primary))
                .cornerRadius(Radius.sm)
                .keyboardShortcut(.cancelAction)
            }
        }
        .padding(Spacing.lg)
        #if os(macOS)
        .frame(minWidth: 480, idealWidth: 640, minHeight: 320, idealHeight: 480)
        #endif
    }

    private func copy() {
        Self.write(text)
        didCopy = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            didCopy = false
        }
    }

    #if os(macOS)
    /// Writes `text` as the only string on `pasteboard` (the general pasteboard by default).
    static func write(_ text: String, to pasteboard: NSPasteboard = .general) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    #else
    /// Writes `text` to `pasteboard` (the general pasteboard by default).
    static func write(_ text: String, to pasteboard: UIPasteboard = .general) {
        pasteboard.string = text
    }
    #endif
}

// MARK: - View extension

public extension View {
    /// Presents a `FUITextSheet` while `item` is non-nil; the sheet's content
    /// comes from the closures, and Close (or dismissal) sets `item` to nil.
    func fuiTextSheet<Item: Identifiable>(
        item: Binding<Item?>,
        title: @escaping (Item) -> String,
        subtitle: ((Item) -> String?)? = nil,
        text: @escaping (Item) -> String
    ) -> some View {
        sheet(item: item) { value in
            FUITextSheet(
                title: title(value),
                subtitle: subtitle?(value),
                text: text(value),
                onClose: { item.wrappedValue = nil }
            )
        }
    }
}
