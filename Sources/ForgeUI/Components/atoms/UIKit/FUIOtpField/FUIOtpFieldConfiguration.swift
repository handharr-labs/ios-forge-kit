import Foundation

/// Value-type configuration for `FUIOtpField`.
public struct FUIOtpFieldConfiguration {
    /// Number of visible OTP cells. Defaults to 6.
    public var length: Int

    public init(length: Int = 6) {
        self.length = length
    }
}
