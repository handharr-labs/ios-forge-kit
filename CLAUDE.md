# CLAUDE.md — iOS Forge Kit

handharr-labs · iOS Forge Kit — shared SPM packages for UIKit/SwiftUI apps. The iOS counterpart of the Web Forge Kit.

## Architecture

- **Glossary (All Terms):** `docs/principles/forge-kit/glossary.md`
- **Design Principles (What & Why):** `docs/principles/forge-kit/design-principles.md`
- **Conventions (What, How, When):** `docs/principles/forge-kit/conventions.md`
- **Directory Structure (What & Where):** `docs/principles/forge-kit/directory-structure.md`
- **iOS Architecture (feature-layer reference):** `docs/principles/ios-architecture/` → links `docs/prep/ios-app-system-design-philosophy.md`

> No tiering on mobile — the Bronze/Silver/Gold model was dropped for the iOS DS (2026-06-29). `ForgeUI` is a single un-tiered, SwiftUI-first design system organized by atomic-design tier (atoms/molecules/organisms).

## Principles

Clean Architecture · DRY · SOLID — apply to all new code.

**Layer dependency rule:** Presentation → Domain ← Data. Domain depends on nothing.

```
Presentation  →  ViewController + ViewModel (@MainActor, Combine @Published)
Domain        →  UseCase + RepositoryProtocol + Request + FetchPolicy + Model + Service/Spec
Data          →  Repository + DataSource + DTO + Mapper + APIRequest
Application    →  Coordinator (DI composition root; owns UINavigationController)
```

## Packages

One root `Package.swift` exposes three library products. Downstream apps install via `.package(url:, from:)`; playground apps via `.package(name: "iOSForgeKit", path: "..")` + `.product(name:package:)`.

| Product | Scope | Purpose |
|---|---|---|
| `Core` | Platform-agnostic | `FetchPolicy`, `Request<Query,Path>`, `AnalyticsEvent`/`AnalyticsGatewayProtocol` (+ Console/NoOp). No UIKit, no deps. |
| `AppleClient` | Apple-platform IO | `APIClient`, `WebSocketClient` (actor) + `ChannelRouter`, image loading, `LocalDataSourceProtocol`, `Coordinator`. Deps: `Core`. |
| `ForgeUI` | Design system | Token-first, SwiftUI-first UIKit + SwiftUI components; `FUI*` prefix; `*Configuration` API. Un-tiered; organized by atomic-design tier (atoms/molecules/organisms). |

## Key Rules

- Domain never imports `AppleClient`, `ForgeUI`, Infrastructure, or External (UIKit, URLSession, AVFoundation).
- `Core` has zero internal/UIKit deps. `AppleClient` depends on `Core`. `ForgeUI` is standalone.
- Only the Data layer imports `Core`/`AppleClient`; only Presentation + Application import `ForgeUI`.
- DI is manual initializer injection at the **Coordinator** — no `ServiceLocator`.
- `ForgeUI` holds no domain or feature logic. `MDS*` symbols are retired in favor of `FUI*`.
- Features live in downstream apps (or the playground), never in the kit packages.

## Key Patterns to Know Cold

- DTO → Mapper → Domain Model (Mapper is the only type that knows both)
- `FetchPolicy` (.fresh / .cached / .strict) travels on `Request` from ViewModel to Repository
- `Request<Query, Path>` is the unified UseCase input — adding a field doesn't break call sites; HTTP structs use `*APIRequest`
- `@MainActor` on ViewModel — all state mutation on main, no `DispatchQueue.main.async`
- `actor` for shared mutable transport (`WebSocketClient`); one socket, channel-multiplexed
- `async let` for a fixed N concurrent fetches, `withThrowingTaskGroup` for variable N
- `defer { isLoading = false }` · `[weak self]` in escaping closures
- Unit tests: mock the layer below, assert on the layer you just built

## Prototypes + Playground

The kit ships with prototype app modules and a runnable playground that exercises them — neither is published.

- **Prototype modules:** `Prototypes/{MusicApp, ChatApp, HotelBookingApp, StoryViewerApp, UberEatsApp}` — each a self-contained SPM package with its own public `Coordinator`, consuming the kit via `.package(name: "iOSForgeKit", path: "../..")`.
- **Playground host:** `playground/Playground.xcodeproj` + `playground/Playground/` — the only runnable target. `HomeViewController` hub ("Forge Kit") launches each prototype via Coordinators and opens the ForgeUI catalog (`ForgeUICatalogViewController`). Entry: `AppDelegate` + `SceneDelegate`; deep links + notifications wired here.
- **APIs used by the prototypes:** iTunes Search/Lookup, MockAPI.io (playlist CRUD), and mock JSON local sources.
- Build/run: open `playground/Playground.xcodeproj`, scheme `Playground`, any iOS simulator.
- The legacy `Melodify` host target was retired ("no more melodify"); its music code already lived in `MusicApp`.

## Temp / Interview Docs

`docs/prep/` holds all interview-prep material — `ios-app-system-design-philosophy.md` (the generic iOS app skeleton), `SystemDesign/` (per-app writeups), `scenarios/`, and `conventions/` — maintained by the `sysdesign-*` skills. `temp-dir/` holds scratch prep notes.
