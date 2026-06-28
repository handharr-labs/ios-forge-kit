import UIKit

public final class FUIAudioPlayerView: UIView {
    public var onPlayPause: (() -> Void)?

    private let playPauseButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "waveform"), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let durationLabel: UILabel = {
        let l = UILabel()
        l.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Radius.lg
        addSubview(playPauseButton)
        addSubview(durationLabel)
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.sm),
            playPauseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.md),
            playPauseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.sm),
            playPauseButton.widthAnchor.constraint(equalToConstant: 24),
            playPauseButton.heightAnchor.constraint(equalToConstant: 24),

            durationLabel.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: Spacing.sm),
            durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.md)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func configure(with config: FUIAudioPlayerConfiguration) {
        durationLabel.text = config.duration
        let iconName = config.isPlaying ? "pause.fill" : "waveform"
        playPauseButton.setImage(UIImage(systemName: iconName), for: .normal)

        switch config.variant {
        case .outgoing:
            backgroundColor            = FUIColor.primary
            playPauseButton.tintColor  = FUIColor.onPrimary
            durationLabel.textColor    = FUIColor.onPrimary
        case .incoming:
            backgroundColor            = FUIColor.surfaceElevated
            playPauseButton.tintColor  = FUIColor.primary
            durationLabel.textColor    = FUIColor.textPrimary
        }
    }

    @objc private func togglePlayPause() {
        onPlayPause?()
    }
}
