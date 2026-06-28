import Foundation

/// Value-type configuration for `FUIPageControl`.
public struct FUIPageControlConfiguration {
    public var numberOfPages: Int
    public var currentPage: Int

    public init(numberOfPages: Int, currentPage: Int = 0) {
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
    }
}
