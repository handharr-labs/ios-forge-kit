import UIKit

/// A token-styled page-indicator row wrapping `UIPageControl`.
///
/// `currentPageIndicatorTintColor` = `FUIColor.primary`.
/// `pageIndicatorTintColor` = `FUIColor.line`.
/// `onPageChange` fires when the user taps a dot.
public final class FUIPageControl: UIView {

    // MARK: - Sub-view

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = FUIColor.primary
        pc.pageIndicatorTintColor = FUIColor.line
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    // MARK: - Callback

    /// Fired when the user taps a page indicator dot; receives the new page index.
    public var onPageChange: ((Int) -> Void)?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: topAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    public func configure(with config: FUIPageControlConfiguration) {
        pageControl.numberOfPages = config.numberOfPages
        pageControl.currentPage = config.currentPage
    }

    // MARK: - Actions

    @objc private func pageChanged() {
        onPageChange?(pageControl.currentPage)
    }
}
