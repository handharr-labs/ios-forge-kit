import SwiftUI

/// A transient status message presented as a floating capsule over content.
///
/// Use the `FUIToast` view directly when you need full layout control, or attach
/// `.fuiToast(isPresented:message:status:)` to any view for an overlay that
/// auto-dismisses after ~2.5 s.
///
/// - Note: Functional, clean, minimal animation.
public struct FUIToast: View {
    public let message: String
    public let status: FUIStatus

    public init(message: String, status: FUIStatus = .info) {
        self.message = message
        self.status = status
    }

    public var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: status.symbolName)
                .font(.fuiLabel)
                .foregroundColor(status.swiftUIOnFill)
            Text(message)
                .font(.fuiBody)
                .foregroundColor(status.swiftUIOnFill)
                .lineLimit(2)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm + 2)
        .background(status.swiftUIFill)
        .clipShape(Capsule())
        .shadow(
            color: Color.black.opacity(Double(Elevation.mid.opacity)),
            radius: Elevation.mid.radius,
            x: Elevation.mid.offset.width,
            y: Elevation.mid.offset.height
        )
    }
}

// MARK: - ViewModifier

private struct FUIToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let status: FUIStatus

    @State private var task: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            if isPresented {
                FUIToast(message: message, status: status)
                    .padding(.horizontal, Spacing.md)
                    .padding(.bottom, Spacing.lg)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.25), value: isPresented)
                    .onAppear {
                        task?.cancel()
                        task = Task {
                            try? await Task.sleep(nanoseconds: 2_500_000_000)
                            guard !Task.isCancelled else { return }
                            await MainActor.run {
                                withAnimation { isPresented = false }
                            }
                        }
                    }
                    .onDisappear { task?.cancel() }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}

// MARK: - View extension

public extension View {
    /// Overlays a `FUIToast` at the bottom of the view and auto-dismisses it after ~2.5 s.
    func fuiToast(
        isPresented: Binding<Bool>,
        message: String,
        status: FUIStatus = .info
    ) -> some View {
        modifier(FUIToastModifier(isPresented: isPresented, message: message, status: status))
    }
}
