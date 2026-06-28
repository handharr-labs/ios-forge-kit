import SwiftUI

/// Remote image component.
///
/// Uses `AsyncImage` to load from a URL with three phases:
/// - **Loading** — `FUIShimmer` placeholder.
/// - **Success** — image clipped to `cornerRadius`, respecting `contentMode` and
///   optional `aspectRatio`.
/// - **Failure / nil URL** — broken-image icon (`FUIIcons.imageBroken`) centered
///   on a `FUIColor.surfaceVariant` fill.
public struct FUIImage: View {
    public let url: URL?
    public let cornerRadius: CGFloat
    public let contentMode: ContentMode
    public let aspectRatio: CGFloat?

    public init(
        url: URL?,
        cornerRadius: CGFloat = Radius.md,
        contentMode: ContentMode = .fill,
        aspectRatio: CGFloat? = nil
    ) {
        self.url = url
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
        self.aspectRatio = aspectRatio
    }

    public var body: some View {
        GeometryReader { geo in
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    FUIShimmer(
                        width: geo.size.width,
                        height: geo.size.height,
                        cornerRadius: cornerRadius
                    )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                case .failure:
                    errorPlaceholder(size: geo.size)
                @unknown default:
                    errorPlaceholder(size: geo.size)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .applyAspectRatio(aspectRatio)
    }

    private func errorPlaceholder(size: CGSize) -> some View {
        ZStack {
            Color(FUIColor.surfaceVariant)
            Image(systemName: FUIIcons.imageBroken)
                .font(.system(size: min(size.width, size.height) * 0.3))
                .foregroundColor(Color(FUIColor.textDisabled))
        }
    }
}

// MARK: - Helpers

private extension View {
    @ViewBuilder
    func applyAspectRatio(_ ratio: CGFloat?) -> some View {
        if let ratio {
            self.aspectRatio(ratio, contentMode: .fit)
        } else {
            self
        }
    }
}
