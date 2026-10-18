#if canImport(UIKit)
import UIKit

/// The native color class of the current platform — `UIColor` on UIKit platforms.
public typealias PlatformColor = UIColor
/// The native font class of the current platform — `UIFont` on UIKit platforms.
public typealias PlatformFont = UIFont
#else
import AppKit

/// The native color class of the current platform — `NSColor` on macOS.
public typealias PlatformColor = NSColor
/// The native font class of the current platform — `NSFont` on macOS.
public typealias PlatformFont = NSFont
#endif
