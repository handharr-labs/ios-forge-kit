import SwiftUI

/// A small grab handle drawn at the top of a `FUIBottomSheet` content area.
public struct FUIBottomSheetHandle: View {
    public init() {}

    public var body: some View {
        Capsule()
            .fill(Color(FUIColor.lineStrong))
            .frame(width: 36, height: 4)
            .padding(.top, Spacing.sm)
    }
}

// MARK: - ViewModifier

private struct FUIBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let detents: Set<PresentationDetent>
    let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                VStack(spacing: Spacing.none) {
                    FUIBottomSheetHandle()
                    sheetContent()
                }
                .presentationDetents(detents)
                .presentationDragIndicator(.hidden) // we draw our own handle
            }
    }
}

public extension View {
    /// Wraps the receiver in a SwiftUI `.sheet` with `presentationDetents`,
    /// a `FUIBottomSheetHandle`, and Forge token background.
    func fuiBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(FUIBottomSheetModifier(
            isPresented: isPresented,
            detents: detents,
            sheetContent: content
        ))
    }
}
