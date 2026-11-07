# Bruvbox

Faded blues, moss greens, warm neutrals. One source for colors **and combinations**, with web, Neovim and terminal adapters.

Bruvbox started as Joen Tolgraven's heavily modified Gruvbox fork. The original 79 active colors are preserved exactly. The canonical definitions now live in JSON rather than Vimscript.

| Source | Responsibility |
| --- | --- |
| `tokens/palette.tokens.json` | Literal colors; original names and cterm metadata |
| `tokens/dark.tokens.json`, `tokens/light.tokens.json` | Semantic aliases: surfaces, text, accents, tints, syntax and terminal slots |
| `theme.json` | Variant composition and 28 reusable foreground/background combinations |
| `adapters/` | Target-specific mappings, with no literal colors |
| `src/theme.mjs` | Validation, alias resolution, combination inheritance, contrast and JS API |
| `src/render.mjs` | Output formats |

Colors use the [DTCG 2025.10](https://www.designtokens.org/tr/2025.10/format/) format. The compiler intentionally supports a **documented subset**: opaque sRGB colors, groups and whole-token aliases. It is not a complete DTCG resolver. Combinations use a separate, versioned, application-independent schema; exported DTCG files expose their color channels as ordinary color tokens.

## Use the outputs

Everything in `dist/` is committed. Consumers need no npm installation or build step.

- `dist/web/bruvbox.css`: CSS custom properties, dark by default; switch with `data-bruvbox="light"` or `"dark"` on a root/container.
- `dist/web/_bruvbox.scss`: Sass variables, variant maps, lookup functions and combination mixin.
- `dist/json/`: fully resolved colors and combinations, including contrast ratios.
- `dist/dtcg/`: self-contained portable token documents.
- `dist/clojure/bruvbox/theme.cljc`: CLJ/CLJS palette maps matching tolgrAVen's Highlight.js palette keys.
- `dist/{kitty,ghostty,alacritty,iterm}/`: dark/light truecolor terminal presets.
- `dist/base16/`: explicitly lossy Base16 projections for Tinted Theming.
- `dist/preview.html`: standalone palette/combination catalogue; open it in a browser.
- `dist/contrast.json`: measured foreground/background contrast for every combination.

### Web / submodule

```fish
git submodule add https://github.com/tolgraven/bruvbox.git vendor/bruvbox
```

Commit `.gitmodules` and the submodule pointer. CI checks out submodules recursively. Pin updates to a reviewed commit; do not use `git submodule update --remote` implicitly during builds.

Load `dist/web/bruvbox.css` through your CSS pipeline, then:

```scss
@use "vendor/bruvbox/dist/web/bruvbox" as bb;

.card {
  @include bb.combination("panel"); // Runtime CSS variables; follows dark/light.
  border-width: 1px;
  border-style: solid;
}
.notice { @include bb.combination("warning"); }
.brand { color: bb.$bruvbox-accent-orange; } // Literal dark color.
.light-only { color: bb.color("accent.orange", "light"); }
.link { color: bb.css-color("accent.blue"); } // Runtime var(...).
```

`@use` resolves relative to the importing file or configured Sass load paths; add the repository root as a load path for the example above. The Sass module does not emit CSS variables itself. Import the CSS once through the owning bundle, or copy it as a stylesheet. See [the tolgrAVen integration recipe](docs/tolgraven.md) for its existing build and CLJS theme.

### JavaScript

```js
import {loadTheme, getColor, getCombination} from './vendor/bruvbox/src/theme.mjs';
const theme = await loadTheme(); // Node build-time API; resolves relative to module.
getColor(theme, 'accent.orange');
getCombination(theme, 'error', 'dark'); // {foreground, background, border, contrast}
```

For the browser, import/fetch `dist/json/bruvbox-dark.json`; the compiler uses Node filesystem APIs and should stay out of client bundles.

### Neovim

Install this repository as a plugin. Requires Neovim 0.11+; runtime has no npm, Lua plugin or color-library dependency.

```lua
-- lazy.nvim
{
  'tolgraven/bruvbox',
  lazy = false,
  priority = 1000,
  config = function()
    require('bruvbox').setup({ variant = 'auto', italic = true })
    vim.cmd.colorscheme('bruvbox-next')
  end,
}
```

`auto` follows `background`; explicit `dark`/`light`, `transparent`, and `overrides` are supported. `overrides` is a highlight map or `function(theme) return {...} end`; entries replace whole highlight definitions. Read colors via `require('bruvbox').get().colors['accent.orange']` and combinations via `.combinations.error`.

The new adapter covers core UI, syntax, Tree-sitter, LSP semantic tokens, diagnostics, GitSigns and Telescope, with small explicit Clojure mappings. It is a structured replacement, **not pixel-identical parity with every legacy language/plugin customization**. Existing `colorscheme bruvbox` remains the Vimscript theme, using the same generated palette. Original documentation lives in [docs/legacy-vim.md](docs/legacy-vim.md). Its glyphs/Airline behavior and legacy options are not transplanted into the new adapter.

### Terminals on macOS

- **Kitty:** `include /absolute/path/to/bruvbox/dist/kitty/bruvbox-dark.conf` in `kitty.conf`.
- **Ghostty:** `config-file = /absolute/path/to/bruvbox/dist/ghostty/bruvbox-dark` in its config.
- **Alacritty:** add the generated TOML path to `[general].import`.
- **iTerm2:** `open /absolute/path/to/bruvbox/dist/iterm/bruvbox-dark.itermcolors`, then choose the imported preset in profile colors.

Presets define 16 RGB ANSI slots, foreground/background, cursor and selection. They do not remap every 256-color slot or affect applications emitting their own RGB values. Palette files are structurally tested; native terminal import/rendering still needs a check on your Mac.

## Edit and build

Node 22+. Generation itself has **zero package dependencies**:

```fish
node scripts/build.mjs
node scripts/build.mjs --check
node scripts/build.mjs --contrast
node scripts/build.mjs --out /path/to/export-root
```

Custom output preserves the `dist/`, `lua/` and `autoload/` directory layout. Build/check paths are independent of cwd. Build fails on invalid references, alias/combination cycles, unsupported color features, output name collisions and declared contrast violations. `--check` also detects missing, changed and obsolete artifacts.

For development checks:

```fish
npm ci
npm test
npm run check
nvim --headless -u NONE --cmd 'set rtp+=.' -l test/nvim.lua
```

Change tokens/aliases/combinations, regenerate, review the catalogue and contrast report, then commit sources and outputs together. The light variant is a new semantic mapping over the inherited light palette; it is not a claim of established visual parity. Some combinations intentionally remain below WCAG AA normal-text contrast. `minContrast` can enforce a requirement per combination without silently recoloring the palette.

See [schema and extension guide](docs/schema.md), [research and design decisions](docs/research.md), and [migration/integration](docs/tolgraven.md).

## Attribution

Bruvbox by Joen Tolgraven; derived from [Gruvbox by morhetz](https://github.com/morhetz/gruvbox). The original project declares MIT/X11 licensing. See [NOTICE](NOTICE) and the preserved [legacy README](docs/legacy-vim.md#license). New compiler and adapter code is MIT licensed.
