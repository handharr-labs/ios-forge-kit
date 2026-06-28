import SwiftUI

/// Value slider.
///
/// Wraps SwiftUI `Slider` with `FUIColor.primary` tint and an optional discrete
/// `step`. When `isEnabled` is `false` the control renders at reduced opacity
/// and ignores interaction.
public struct FUISlider: View {
    private let range: ClosedRange<Double>
    private let step: Double?
    public let isEnabled: Bool
    public let onChanged: (Double) -> Void

    @Binding private var value: Double

    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...1,
        step: Double? = nil,
        isEnabled: Bool = true,
        onChanged: @escaping (Double) -> Void
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }

    public var body: some View {
        Group {
            if let step {
                Slider(value: $value, in: range, step: step) { _ in
                    onChanged(value)
                }
            } else {
                Slider(value: $value, in: range) { _ in
                    onChanged(value)
                }
            }
        }
        .tint(Color(FUIColor.primary))
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
    }
}
