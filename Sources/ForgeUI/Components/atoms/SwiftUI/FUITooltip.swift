import SwiftUI

/// Internal view modifier that surfaces a small tooltip bubble on long-press.
///
/// The bubble uses `FUIColor.surfaceElevated` background, `Elevation.low` shadow,
/// `Radius.sm` corner radius, and `Font.fuiCaption` text. Visibility is toggled
/// by an internal `@State` flag.
public struct FUITooltipModifier: ViewModifier {
    public let text: String
    @State private var isVisible: Bool = false

    public func body(content: Content) -> some View {
        content
            .onLongPressGesture(minimumDuration: 0.4) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isVisible.toggle()
                }
            }
            .overlay(alignment: .top) {
                if isVisible {
                    tooltipBubble
                        .offset(y: -Spacing.lg)
                        .transition(.opacity.combined(with: .scale(scale: 0.92, anchor: .bottom)))
                        .zIndex(1)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                isVisible = false
                            }
                        }
                }
            }
    }

    private var tooltipBubble: some View {
        Text(text)
            .font(.fuiCaption)
            .foregroundColor(Color(FUIColor.onSurface))
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: Radius.sm)
                    .fill(Color(FUIColor.surfaceElevated))
                    .shadow(
                        color: Color(FUIColor.onSurface).opacity(Double(Elevation.low.opacity)),
                        radius: Elevation.low.radius,
                        x: Elevation.low.offset.width,
                        y: Elevation.low.offset.height
                    )
            )
            .fixedSize()
    }
}

public extension View {
    /// Attaches a tooltip bubble that appears on long-press. Dismiss by tapping the bubble.
    func fuiTooltip(_ text: String) -> some View {
        modifier(FUITooltipModifier(text: text))
    }
}
