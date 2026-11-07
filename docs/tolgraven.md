# Integrating with tolgrAVen

This is a concrete integration recipe, not a claim that tolgrAVen has been modified. Inspection found an existing Node Sass build (`scripts/build/styles.mjs`) and a manually duplicated Highlight.js palette in `src/frontend/website/modules/highlight/theme.cljs`. Keep those existing ownership/build boundaries.

## Pin the shared repository

From the website repository:

```fish
git submodule add https://github.com/tolgraven/bruvbox.git vendor/bruvbox
git submodule update --init --recursive
```

Commit the gitlink and `.gitmodules`. For CI with `actions/checkout`, set `submodules: recursive`. Also initialize submodules before Docker build context creation; a gitlink alone is not the source files. Review the exact pinned commit when updating. No npm packages need installing in the submodule for consumption.

## Sass and CSS

Configure the website Sass invocation's load paths to include the website root, then use:

```scss
@use "vendor/bruvbox/dist/web/bruvbox" as bb;

.panel {
  @include bb.combination("panel");
  border: 1px solid bb.css-color("border.default");
}
.warning { @include bb.combination("warning"); }
.brand { color: bb.$bruvbox-accent-orange; }
```

Load/copy `vendor/bruvbox/dist/web/bruvbox.css` into the owning CSS bundle exactly once. It defines `:root` dark defaults and `[data-bruvbox="dark"|"light"]` overrides. The Sass module deliberately emits no CSS by itself. CSS variables use `--bruvbox-` prefixes to avoid overwriting the site's existing names. Existing selectors can adopt them incrementally.

If the site's design wants different meanings for `accent.orange` or `surface.raised`, map those at the application boundary rather than replacing literal hex values throughout the app. Semantic theme names should remain reusable, not acquire webpage-specific component names.

When editing the definitions in the submodule, generate without needing `npm ci`:

```fish
node vendor/bruvbox/scripts/build.mjs
node vendor/bruvbox/scripts/build.mjs --check
```

Optionally wire `--check` into the website build/CI. Source changes and regenerated artifacts should be committed in Bruvbox first, then the website gitlink updated; do not silently dirty the submodule during ordinary website builds.

## Replace the existing CLJS palette duplication

Add `vendor/bruvbox/dist/clojure` to the website's CLJ/CLJS source paths, including whichever path collection is used by browser, tests and SSR. The generated namespace is pure data and has no browser APIs.

Change only the palette definition/require in `website.modules.highlight.theme`:

```clojure
(ns website.modules.highlight.theme
  (:require [bruvbox.theme :as shared-theme]))

(def palette (:dark shared-theme/highlight-palettes))
```

All 17 existing dark palette entries match exactly, including `:function`, `:keyword`, `:type`, `:addition` and `:deletion`. Light output is available as `:light`, but selecting it dynamically requires respecting the site's SSR/hydration theme ownership. Do not add an independent browser-only theme switch inside the highlighting module.

## Verify in the consuming repository

Run its required Sass, browser and SSR builds, then inspect highlighted code on cold load, SPA navigation and history return. Verify light/dark handling wherever enabled and check the in-browser Neovim owner separately before changing its installed colorscheme. This repository's generator and headless-Neovim tests cannot establish those application flows.
