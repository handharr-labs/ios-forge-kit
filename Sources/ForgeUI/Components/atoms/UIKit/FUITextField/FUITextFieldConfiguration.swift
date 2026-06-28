import Foundation

/// Value-type configuration for `FUITextField`.
/// When `errorText` is non-nil the field renders in its error state.
public struct FUITextFieldConfiguration {
    public var label: String?
    public var placeholder: String?
    public var text: String?
    public var iconName: String?
    public var isSecure: Bool
    public var errorText: String?

    public init(
        label: String? = nil,
        placeholder: String? = nil,
        text: String? = nil,
        iconName: String? = nil,
        isSecure: Bool = false,
        errorText: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self.text = text
        self.iconName = iconName
        self.isSecure = isSecure
        self.errorText = errorText
    }
}
