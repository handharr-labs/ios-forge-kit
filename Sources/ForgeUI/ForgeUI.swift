// ForgeUI — iOS Forge Kit design system.
// Token-first, SwiftUI-first (UIKit only where SwiftUI isn't feasible, always with a
// `Representable` bridge). Every public type is prefixed `FUI`. The native mirror of
// the Flutter `forge_ui` kit. Components are organized atomic-design first:
// Components/<atoms|molecules|organisms>/<SwiftUI|UIKit>/.
//
// Tokens (Tokens/):
//   FUIColor (semantic dynamic palette) · Typography (8-step + Font.fui*) ·
//   Spacing (8pt: none…xxxl) · Radius (xs…xl + full) · Elevation/ShadowToken ·
//   FUIStatus (status→color) · FUIIcons (curated SF Symbols vocabulary)
//
// SwiftUI components (the default — Components/<tier>/SwiftUI/):
//   Atoms:     FUIText, FUIIcon, FUIIconButton, FUITag, FUIDivider, FUICheckbox,
//              FUIRadio, FUISwitch, FUIShimmer, FUIProgressIndicator, FUISlider,
//              FUITooltip(.fuiTooltip), FUIImage, FUIFab, FUISearchField,
//              FUIButton (ButtonStyle), FUIBadge (+ .mdsBadge), FUIAvatar
//   Molecules: FUICard, FUIBanner, FUIChip, FUICheckboxListTile, FUIRadioListTile,
//              FUIToggleListTile, FUISegmentedControl, FUISelect, FUIStepper,
//              FUIToast(.fuiToast), FUITimeline, FUIChatBubble, FUIFileUpload,
//              FUILoadingOverlay, FUITextArea
//   Organisms: FUIDialog(.fuiDialog), FUITextSheet(.fuiTextSheet), FUITabs,
//              FUIAccordion, FUIBottomNavBar,
//              FUIBottomSheet(.fuiBottomSheet), FUIContextMenu(.fuiContextMenu),
//              FUICalendar, FUICountryPicker(.fuiCountryPicker), FUIStories,
//              FUIEmptyState
//
// UIKit components (only where SwiftUI isn't feasible — Components/<tier>/UIKit/):
//   Atoms:     FUILoading, FUIPrimaryButton, FUITextField, FUIOtpField, FUIPageControl
//   Molecules: FUIMessageBubble, FUIAudioPlayer (+ Representable), FUITrackRow, FUIListTile
//   Organisms: FUIAppBar
//   Each exposes a `*Configuration` value type as its public API. UIKit hosts consume
//   SwiftUI components via `UIHostingView`; there are no UIKit twins of SwiftUI components.
//
// Bridge (generic UIKit ↔ SwiftUI interop — see Bridge/README.md):
//   SwiftUI → UIKit: UIHostingView<Content> (inline) · FUIHostingController<Content> (screen)
//   UIKit → SwiftUI: FUIViewRepresentable<V> (any UIView) + a named FUI*Representable
//                    next to every UIKit component (FUITextFieldRepresentable, …)
//
// Platforms:
//   iOS 16+ and macOS 14+. On macOS only the SwiftUI parts build: tokens are typed as
//   PlatformColor / PlatformFont (UIColor/NSColor, UIFont/NSFont); every UIKit file is
//   wrapped in `#if canImport(UIKit)`; iOS-idiom components (FUICountryPicker,
//   FUIBottomNavBar, FUIBottomSheet, FUIStories) are `#if os(iOS)`.
//
// Catalog:
//   ForgeUICatalogViewController  — live, in-app browser of every token + component
//                                   (light/dark toggle); present from any host.
