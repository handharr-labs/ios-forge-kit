import SwiftUI

/// A horizontal row of labelled segments. The selected segment is lifted to a
/// `surface` pill; the track uses `surfaceVariant`. Fires `onChange` with the
/// new index on each tap.
public struct FUISegmentedControl: View {
    public let segments: [String]
    public let selectedIndex: Int
    public let onChange: (Int) -> Void

    public init(
        segments: [String],
        selectedIndex: Int,
        onChange: @escaping (Int) -> Void
    ) {
        self.segments = segments
        self.selectedIndex = selectedIndex
        self.onChange = onChange
    }

    public var body: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(segments.indices, id: \.self) { index in
                segmentButton(index: index)
            }
        }
        .padding(Spacing.xs)
        .background(Color(FUIColor.surfaceVariant))
        .clipShape(RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
    }

    @ViewBuilder
    private func segmentButton(index: Int) -> some View {
        let isSelected = index == selectedIndex
        Button {
            onChange(index)
        } label: {
            Text(segments[index])
                .font(.fuiLabel)
                .foregroundColor(
                    isSelected
                        ? Color(FUIColor.primary)
                        : Color(FUIColor.textSecondary)
                )
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs + 2)
                .background(
                    isSelected
                        ? Color(FUIColor.surface)
                        : Color.clear
                )
                .clipShape(RoundedRectangle(cornerRadius: Radius.sm, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
