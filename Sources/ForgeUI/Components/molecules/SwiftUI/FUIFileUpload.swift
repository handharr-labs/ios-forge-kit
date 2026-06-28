import SwiftUI

/// A single file entry shown inside an `FUIFileUpload` drop-zone.
public struct FUIUploadFile: Identifiable {
    public let id: String
    public let name: String
    /// Upload progress in the range 0.0 … 1.0.
    public let progress: Double

    public init(id: String, name: String, progress: Double) {
        self.id = id
        self.name = name
        self.progress = progress
    }
}

/// A dashed drop-zone component for selecting files.
///
/// This view is **UI only** — the caller is responsible for wiring a real file
/// picker via `onTap` and driving progress updates by updating `files`.
/// File rows show the file name, a linear progress bar, and a remove button.
///
/// - Note: Functional, clean, minimal animation.
public struct FUIFileUpload: View {
    public let prompt: String
    public let files: [FUIUploadFile]
    public let onTap: (() -> Void)?
    public let onRemove: ((FUIUploadFile) -> Void)?

    public init(
        prompt: String = "Tap to upload",
        files: [FUIUploadFile] = [],
        onTap: (() -> Void)? = nil,
        onRemove: ((FUIUploadFile) -> Void)? = nil
    ) {
        self.prompt = prompt
        self.files = files
        self.onTap = onTap
        self.onRemove = onRemove
    }

    public var body: some View {
        VStack(spacing: Spacing.md) {
            // Drop zone
            Button(action: { onTap?() }) {
                VStack(spacing: Spacing.sm) {
                    Image(systemName: FUIIcons.upload)
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(Color(FUIColor.textSecondary))
                    Text(prompt)
                        .font(.fuiBody)
                        .foregroundColor(Color(FUIColor.textSecondary))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xl)
                .background(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1.5, dash: [6])
                        )
                        .foregroundColor(Color(FUIColor.line))
                )
            }
            .buttonStyle(.plain)

            // File rows
            if !files.isEmpty {
                VStack(spacing: Spacing.sm) {
                    ForEach(files) { file in
                        fileRow(file)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func fileRow(_ file: FUIUploadFile) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: FUIIcons.file)
                .font(.fuiLabel)
                .foregroundColor(Color(FUIColor.textSecondary))

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(file.name)
                    .font(.fuiCaption)
                    .foregroundColor(Color(FUIColor.textPrimary))
                    .lineLimit(1)
                    .truncationMode(.middle)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: Radius.xs)
                            .fill(Color(FUIColor.surfaceVariant))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: Radius.xs)
                            .fill(Color(FUIColor.primary))
                            .frame(width: geo.size.width * max(0, min(1, file.progress)), height: 4)
                    }
                }
                .frame(height: 4)
            }

            Button(action: { onRemove?(file) }) {
                Image(systemName: FUIIcons.clear)
                    .font(.fuiLabel)
                    .foregroundColor(Color(FUIColor.textDisabled))
            }
            .buttonStyle(.plain)
        }
        .padding(Spacing.sm)
        .background(Color(FUIColor.surfaceElevated))
        .cornerRadius(Radius.sm)
    }
}
