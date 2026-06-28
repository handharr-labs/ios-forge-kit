import SwiftUI

/// A numeric stepper with decrement (−) and increment (+) icon buttons flanking
/// the current value. Clamps to `range`; the appropriate button is disabled at
/// each boundary. Fires `onChanged` with the updated value on each tap.
public struct FUIStepper: View {
    public let value: Int
    public let range: ClosedRange<Int>
    public let step: Int
    public let onChanged: (Int) -> Void

    public init(
        value: Int,
        range: ClosedRange<Int> = 0...99,
        step: Int = 1,
        onChanged: @escaping (Int) -> Void
    ) {
        self.value = value
        self.range = range
        self.step = step
        self.onChanged = onChanged
    }

    private var canDecrement: Bool { value - step >= range.lowerBound }
    private var canIncrement: Bool { value + step <= range.upperBound }

    public var body: some View {
        HStack(spacing: Spacing.none) {
            stepButton(icon: FUIIcons.remove, enabled: canDecrement) {
                onChanged(max(range.lowerBound, value - step))
            }

            Text("\(value)")
                .font(.fuiLabel)
                .foregroundColor(Color(FUIColor.textPrimary))
                .frame(minWidth: 40)
                .multilineTextAlignment(.center)

            stepButton(icon: FUIIcons.add, enabled: canIncrement) {
                onChanged(min(range.upperBound, value + step))
            }
        }
        .background(Color(FUIColor.surfaceVariant))
        .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                .stroke(Color(FUIColor.line), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func stepButton(icon: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.fuiLabel)
                .foregroundColor(enabled ? Color(FUIColor.primary) : Color(FUIColor.textDisabled))
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}
