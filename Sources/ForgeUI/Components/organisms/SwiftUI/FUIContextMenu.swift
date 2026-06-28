import SwiftUI

/// One action shown in a `.fuiContextMenu` overlay.
public struct FUIContextAction {
    public let title: String
    public let icon: String?
    public let isDestructive: Bool
    public let handler: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        isDestructive: Bool = false,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.handler = handler
    }
}

// MARK: - ViewModifier

private struct FUIContextMenuModifier: ViewModifier {
    let actions: [FUIContextAction]

    func body(content: Content) -> some View {
        content
            .contextMenu {
                ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
                    if action.isDestructive {
                        Button(role: .destructive, action: action.handler) {
                            if let icon = action.icon {
                                Label(action.title, systemImage: icon)
                            } else {
                                Text(action.title)
                            }
                        }
                    } else {
                        Button(action: action.handler) {
                            if let icon = action.icon {
                                Label(action.title, systemImage: icon)
                            } else {
                                Text(action.title)
                            }
                        }
                    }
                }
            }
    }
}

public extension View {
    /// Attaches a SwiftUI `.contextMenu` to the receiver using `[FUIContextAction]`.
    /// Destructive actions are rendered with `Button(role: .destructive)`.
    func fuiContextMenu(_ actions: [FUIContextAction]) -> some View {
        modifier(FUIContextMenuModifier(actions: actions))
    }
}
