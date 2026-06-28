# ForgeUI web showcase

A static, single-file showcase of the `ForgeUI` design system — the web analog of the
in-app `ForgeUICatalogViewController`. It's the closest counterpart to the Flutter Forge
Kit's `playground/web`, with one important difference:

> **iOS UIKit/SwiftUI can't run in a browser.** Unlike Flutter (which compiles the same
> widgets to web), there's no supported path to render the *real* `ForgeUI` components on
> the web. So this page renders the **design tokens live** (colors, type scale, spacing,
> radius — they're just values) and **catalogues the components** by tier. To see the
> components actually rendered, open `playground/Playground.xcodeproj` in a simulator.

## What's here

- `index.html` — the **Forge Kit hub** (home): cards for the ForgeUI catalog + the five
  prototype apps. Mirrors the in-app `HomeViewController` ("Forge Kit").
- `forgeui.html` — the **ForgeUI showcase**, reached from the home hub's "ForgeUI Catalog"
  card. The web analog of `ForgeUICatalogViewController`.
- `favicon.svg` — the anvil mark.

The ForgeUI card opens the live token showcase; the prototype cards link to their source
(they can only *run* in an iOS simulator, so they're catalogued, not rendered).

The signature interaction is the **"Resolve for: Light / Dark"** toggle in the token
section: it flips every dynamic/system swatch between its resolved light and dark hex
while the fixed brand colors hold — demonstrating the kit's actual semantic-`UIColor`
behavior (dark mode for free).

## Run locally

It's a static file — just open it:

```sh
open playground/web/index.html
# or serve it
python3 -m http.server -d playground/web 8080   # → http://localhost:8080
```

## Publish

A GitHub Actions workflow (`.github/workflows/pages.yml`) publishes this folder to GitHub
Pages on push to `main`. Enable it once under **Settings → Pages → Source: GitHub Actions**.

## Keeping it in sync

The token values and component inventory are hardcoded in the `<script>` data block at the
bottom of `index.html` (mirroring `Sources/ForgeUI/Tokens/*` and the `Components/` tree).
When the kit's tokens or component set change, update those arrays.
