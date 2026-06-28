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
//              FUILoadingOverlay
//   Organisms: FUIDialog(.fuiDialog), FUITabs, FUIAccordion, FUIBottomNavBar,
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
// Catalog:
//   ForgeUICatalogViewController  — live, in-app browser of every token + component
//                                   (light/dark toggle); present from any host.
