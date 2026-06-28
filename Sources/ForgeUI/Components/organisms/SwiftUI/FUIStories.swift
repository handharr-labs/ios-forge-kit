import SwiftUI

// MARK: - Model

/// One story segment: consumer-supplied content shown for a fixed duration
/// before the player auto-advances to the next item.
public struct FUIStoryItem: Identifiable {
    public let id: String
    public let content: AnyView

    public init(id: String, content: AnyView) {
        self.id = id
        self.content = content
    }
}

// MARK: - Component

/// Full-screen story viewer driven by a `Timer`. Segmented progress bars track
/// playback across the top; tap the left third to go back, right two-thirds to
/// advance; press-and-hold pauses the current segment.
public struct FUIStories: View {
    public let items: [FUIStoryItem]
    public let onFinish: (() -> Void)?

    @State private var currentIndex = 0
    @State private var progress: Double = 0
    @State private var isPaused = false
    @State private var timer: Timer?

    private let segmentDuration: TimeInterval = 5.0
    private let tickInterval: TimeInterval = 0.05

    public init(items: [FUIStoryItem], onFinish: (() -> Void)? = nil) {
        self.items = items
        self.onFinish = onFinish
    }

    // MARK: Body

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // Content
                if !items.isEmpty {
                    items[currentIndex].content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                }

                // Segmented progress bars
                VStack(spacing: Spacing.none) {
                    HStack(spacing: Spacing.xs) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, _ in
                            SegmentBar(
                                state: segmentState(for: index),
                                progress: index == currentIndex ? progress : 0
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.sm)
                    .padding(.top, Spacing.sm)
                    Spacer()
                }

                // Tap zones
                HStack(spacing: Spacing.none) {
                    Color.clear
                        .frame(width: geo.size.width / 3)
                        .contentShape(Rectangle())
                        .onTapGesture { goBack() }

                    Color.clear
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture { goForward() }
                }

                // Long-press zone
                Color.clear
                    .contentShape(Rectangle())
                    .onLongPressGesture(minimumDuration: 0.2, pressing: { pressing in
                        isPaused = pressing
                        if pressing {
                            pauseTimer()
                        } else {
                            resumeTimer()
                        }
                    }, perform: {})
            }
            .background(Color.black)
            .ignoresSafeArea()
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }

    // MARK: Navigation

    private func goForward() {
        if currentIndex < items.count - 1 {
            currentIndex += 1
            resetProgress()
        } else {
            stopTimer()
            onFinish?()
        }
    }

    private func goBack() {
        if currentIndex > 0 {
            currentIndex -= 1
            resetProgress()
        } else {
            resetProgress()
        }
    }

    // MARK: Timer management

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { _ in
            guard !isPaused else { return }
            progress += tickInterval / segmentDuration
            if progress >= 1.0 {
                progress = 1.0
                stopTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    goForward()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resumeTimer() {
        startTimer()
    }

    private func resetProgress() {
        stopTimer()
        progress = 0
        startTimer()
    }

    // MARK: Helpers

    private func segmentState(for index: Int) -> SegmentState {
        if index < currentIndex { return .done }
        if index == currentIndex { return .active }
        return .upcoming
    }
}

// MARK: - Segment bar

private enum SegmentState { case done, active, upcoming }

private struct SegmentBar: View {
    let state: SegmentState
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.35))
                Capsule()
                    .fill(Color.white)
                    .frame(width: geo.size.width * fillFactor)
            }
        }
        .frame(height: 3)
    }

    private var fillFactor: Double {
        switch state {
        case .done: return 1.0
        case .active: return max(0, min(1, progress))
        case .upcoming: return 0
        }
    }
}
