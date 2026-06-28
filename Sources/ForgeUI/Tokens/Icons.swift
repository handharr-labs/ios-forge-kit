import Foundation

/// The kit's curated icon vocabulary. Semantic, brand-controlled glyph names so
/// call sites never reach for raw SF Symbol strings — the same token-first
/// discipline applied to colors and spacing. Backed by SF Symbols today (the
/// native icon system, no bundled assets), repointable to a custom symbol set
/// later without touching a single call site.
///
/// Usage: `Image(systemName: FUIIcons.search)` (SwiftUI) ·
/// `UIImage(systemName: FUIIcons.search)` (UIKit).
public enum FUIIcons {
    // Navigation / chevrons
    public static let chevronUp = "chevron.up"
    public static let chevronDown = "chevron.down"
    public static let chevronLeft = "chevron.left"
    public static let chevronRight = "chevron.right"
    public static let back = "arrow.left"
    public static let forward = "arrow.right"
    public static let close = "xmark"

    // Actions
    public static let search = "magnifyingglass"
    public static let add = "plus"
    public static let remove = "minus"
    public static let edit = "pencil"
    public static let delete = "trash"
    public static let share = "square.and.arrow.up"
    public static let more = "ellipsis"
    public static let moreVertical = "ellipsis"
    public static let filter = "line.3.horizontal.decrease"
    public static let settings = "gearshape"
    public static let refresh = "arrow.clockwise"
    public static let clear = "xmark.circle.fill"
    public static let check = "checkmark"

    // Status
    public static let info = "info.circle.fill"
    public static let success = "checkmark.circle.fill"
    public static let warning = "exclamationmark.triangle.fill"
    public static let error = "xmark.octagon.fill"

    // Media / content
    public static let play = "play.fill"
    public static let pause = "pause.fill"
    public static let image = "photo"
    public static let imageBroken = "photo.badge.exclamationmark"
    public static let file = "doc"
    public static let upload = "arrow.up.doc"
    public static let camera = "camera"
    public static let calendar = "calendar"
    public static let location = "mappin.and.ellipse"

    // People / social
    public static let person = "person.crop.circle"
    public static let bell = "bell.fill"
    public static let heart = "heart"
    public static let heartFilled = "heart.fill"
    public static let star = "star"
    public static let starFilled = "star.fill"

    // Selection controls
    public static let checkboxOn = "checkmark.square.fill"
    public static let checkboxOff = "square"
    public static let radioOn = "largecircle.fill.circle"
    public static let radioOff = "circle"
}
