import SwiftUI
import UIKit

/// UIViewRepresentable wrapper for FUIAudioPlayerView.
/// FUIAudioPlayerView is the only UIKit component in the DS with no clean native
/// SwiftUI equivalent — stateful play/pause + waveform icon requires UIButton lifecycle.
public struct FUIAudioPlayerRepresentable: UIViewRepresentable {
    public let configuration: FUIAudioPlayerConfiguration
    public let onPlayPause: () -> Void

    public init(configuration: FUIAudioPlayerConfiguration, onPlayPause: @escaping () -> Void) {
        self.configuration = configuration
        self.onPlayPause = onPlayPause
    }

    public func makeUIView(context: Context) -> FUIAudioPlayerView {
        let view = FUIAudioPlayerView()
        view.onPlayPause = onPlayPause
        return view
    }

    public func updateUIView(_ uiView: FUIAudioPlayerView, context: Context) {
        uiView.configure(with: configuration)
    }
}
