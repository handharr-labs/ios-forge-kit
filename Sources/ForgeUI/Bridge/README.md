# `Bridge/` — UIKit ↔ SwiftUI interop

**Not a component. Not tiered.** This is the generic framework-interop layer that lets
any UIKit code consume a SwiftUI view and any SwiftUI code consume a UIKit component.
It sits beside `Components/` (not inside the atomic-design tree) because a bridge has no
visual identity, no tier, and no `*Configuration` — it's plumbing, parallel to `Tokens/`
and `Catalog/`.

## The two directions

```
                 SwiftUI  →  UIKit                       UIKit  →  SwiftUI
            ┌───────────────────────────┐         ┌───────────────────────────┐
  inline    │  UIHostingView<Content>   │   any    │  FUIViewRepresentable<V>  │
            │  (embed in a UIKit layout)│  UIView  │  (wrap any UIView)        │
            ├───────────────────────────┤         ├───────────────────────────┤
  screen    │  FUIHostingController     │  named   │  FUI<Component>Representable
            │  (push / present a screen)│ component│  (lives next to component)│
            └───────────────────────────┘         └───────────────────────────┘
```

### SwiftUI → UIKit  (generic — no per-component wrappers needed)

Hosting is generic, so two primitives cover every case:

- **`UIHostingView<Content>`** — a `UIView` that hosts a SwiftUI view **inline** inside a
  larger UIKit layout (a table cell, a header, a toolbar slot). No child view controller.
  This is how UIKit hosts consume SwiftUI `ForgeUI` components (e.g. ChatApp's
  `ConversationCell` renders `FUIAvatar` / `FUIBadge` through it).
- **`FUIHostingController<Content>`** — wraps a SwiftUI view as a **whole screen** you can
  push onto a `UINavigationController` or present modally from a Coordinator.

Because these are generic over `Content: View`, there is **no** parallel "UIKit twin" of a
SwiftUI component — you host the SwiftUI component directly.

### UIKit → SwiftUI  (generic escape hatch + per-component named wrappers)

A UIKit component carries a `configure(with:)` API and often callbacks, so wrapping it for
SwiftUI is component-specific:

- **`FUIViewRepresentable<V>`** — the generic escape hatch: wrap *any* `UIView` with a
  `make` (build + wire callbacks) and `update` (apply `configure(with:)`) closure.
- **`FUI<Component>Representable`** — every UIKit component ships a **named** wrapper that
  lives **next to the component** (in its `Components/<tier>/UIKit/<Component>/` folder),
  exposing that component's configuration and callbacks as a first-class SwiftUI `View`.
  This is the standard shape of every `UIKit/` component.

| UIKit component | SwiftUI wrapper (next to it) | Bridged callbacks |
|---|---|---|
| `FUITextField` | `FUITextFieldRepresentable` | `onTextChanged` |
| `FUIOtpField` | `FUIOtpFieldRepresentable` | `onChanged`, `onCompleted` |
| `FUIPageControl` | `FUIPageControlRepresentable` | `onPageChange` |
| `FUILoading` | `FUILoadingRepresentable` | — |
| `FUIPrimaryButton` | `FUIPrimaryButtonRepresentable` | `onTap` |
| `FUIMessageBubble` | `FUIMessageBubbleRepresentable` | — |
| `FUIListTile` | `FUIListTileRepresentable` | `onTap` |
| `FUITrackRow` | `FUITrackRowRepresentable` | — |
| `FUIAudioPlayer` | `FUIAudioPlayerRepresentable` | `onPlayPause` |
| `FUIAppBar` | `FUIAppBarRepresentable` | `onBack`, `onTrailingTap`, `onSearchTextChanged` |

## Rule of thumb

- Generic, component-agnostic interop → lives **here** in `Bridge/`.
- Interop specific to one component (its named representable) → lives **with that
  component**, built on the generic pieces here.
