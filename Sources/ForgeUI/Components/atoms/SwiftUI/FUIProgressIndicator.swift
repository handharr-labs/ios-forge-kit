import SwiftUI

/// Linear or circular progress indicator.
///
/// Pass a `progress` value in `0…1` for determinate mode, or `nil` for
/// indeterminate (spinner / bouncing bar). Tinted with `FUIColor.primary`.
public enum FUIProgressVariant {
    /// A horizontal track with a filled bar.
    case linear
    /// A spinning ring.
    case circular
}

/// Progress indicator. Supports linear and circular variants in
/// both determinate and indeterminate modes.
public struct FUIProgressIndicator: View {
    public let variant: FUIProgressVariant
    /// Determinate value in `0…1`. `nil` = indeterminate.
    public let progress: Double?

    public init(variant: FUIProgressVariant = .circular, progress: Double? = nil) {
        self.variant = variant
        self.progress = progress
    }

    public var body: some View {
        switch variant {
        case .circular:
            circularBody
        case .linear:
            linearBody
        }
    }

    // MARK: Circular

    @ViewBuilder private var circularBody: some View {
        if let value = progress {
            ProgressView(value: value)
                .progressViewStyle(.circular)
                .tint(Color(FUIColor.primary))
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(Color(FUIColor.primary))
        }
    }

    // MARK: Linear

    @ViewBuilder private var linearBody: some View {
        if let value = progress {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Radius.xs)
                        .fill(Color(FUIColor.surfaceVariant))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: Radius.xs)
                        .fill(Color(FUIColor.primary))
                        .frame(width: geo.size.width * max(0, min(1, value)), height: 4)
                }
            }
            .frame(height: 4)
        } else {
            ProgressView()
                .progressViewStyle(.linear)
                .tint(Color(FUIColor.primary))
        }
    }
}
