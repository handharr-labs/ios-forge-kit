import SwiftUI

/// Skeleton placeholder. Renders a rounded rectangle filled with
/// `FUIColor.surfaceVariant` and animates a left-to-right highlight sweep as a
/// `LinearGradient` mask to convey loading state.
public struct FUIShimmer: View {
    public let width: CGFloat?
    public let height: CGFloat
    public let cornerRadius: CGFloat

    @State private var phase: CGFloat = -1

    public init(width: CGFloat? = nil, height: CGFloat, cornerRadius: CGFloat = Radius.sm) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(FUIColor.surfaceVariant))
            .overlay(
                GeometryReader { geo in
                    let w = geo.size.width
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: Color(FUIColor.surface).opacity(0.6), location: 0.4),
                            .init(color: Color(FUIColor.surface).opacity(0.6), location: 0.6),
                            .init(color: .clear, location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: w * 2)
                    .offset(x: phase * w)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(
                    .linear(duration: 1.4)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.5
                }
            }
    }
}

// MARK: - ViewModifier

/// Conditionally overlays a shimmer over any view when `isActive` is true.
public struct FUIShimmerModifier: ViewModifier {
    public let isActive: Bool

    public func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geo in
                if isActive {
                    FUIShimmer(
                        width: geo.size.width,
                        height: geo.size.height,
                        cornerRadius: Radius.sm
                    )
                }
            }
        )
    }
}

public extension View {
    /// Overlays an animated shimmer when `isActive` is `true`.
    func fuiShimmer(isActive: Bool) -> some View {
        modifier(FUIShimmerModifier(isActive: isActive))
    }
}
