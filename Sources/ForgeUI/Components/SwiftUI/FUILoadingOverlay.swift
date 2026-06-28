import SwiftUI
import UIKit

/// Translucent full-screen loading overlay for SwiftUI screens.
/// Visually identical to FUILoadingView (fullscreen variant) — two implementations
/// for two contexts. Embed via .overlay { FUILoadingOverlay() } on any View.
public struct FUILoadingOverlay: View {
    public let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        ZStack {
            Color(FUIColor.surface)
                .opacity(0.8)
                .ignoresSafeArea()
            VStack(spacing: Spacing.sm) {
                ProgressView()
                if let message {
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(Color(FUIColor.textSecondary))
                }
            }
        }
    }
}
