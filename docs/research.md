# Theme infrastructure research and decision

Checked 2026-11-07 against primary project/specification documentation.

## Decision

Keep a single Bruvbox repository: canonical definitions, a small dependency-free Node compiler, generated distributable artifacts, and the Neovim runtime adapter. Web consumers can pin this repo as a submodule; Neovim can install the same repo as a plugin. Splitting definitions and editor ports now would introduce release coordination without improving the actual separation: target-independent data and target adapters already occupy different directories.

Adopt DTCG's existing color/alias representation instead of inventing it. Add a narrowly scoped combination/composition manifest because reusable foreground/background/border relationships are the missing requirement. Use explicit adapters instead of making a terminal's slot names the theme's universal model.

| Infrastructure | Verified capability / constraint | Use here |
| --- | --- | --- |
| [DTCG Format 2025.10](https://www.designtokens.org/tr/2025.10/format/) and [Color](https://www.designtokens.org/tr/2025.10/color/) | Stable community specification for typed JSON tokens, groups and references; not a W3C Recommendation. Color tokens use structured color-space values. | Adopt opaque sRGB colors and whole-token aliases. Export self-contained DTCG documents. Document the subset rather than claiming complete compliance. |
| [Style Dictionary](https://www.styledictionary.org/info/dtcg/) | General multi-platform token transforms; its own docs say full 2025.10 support is still work in progress in v5. | Useful future integration, but not needed as a dependency for these small deterministic adapters. Our published token documents provide an integration boundary; no untested plug-and-play compatibility claim. |
| [Tinted Theming](https://github.com/tinted-theming/home), [Base16/Base24](https://github.com/tinted-theming/base24/blob/main/styling.md) | Broad template ecosystem; Base24 extends Base16 for terminal ANSI colors. Fixed slots constrain richer palettes and relationships. | Generate an explicit lossy Base16 projection; keep 79 colors and combinations in the canonical model. Base24 can be added as another projection without a schema migration. |
| [Tinted8](https://github.com/tinted-theming/home/blob/main/specs/tinted8/styling.md) | Eight input colors plus richer UI/syntax roles; inspected spec identifies itself as 0.2.0-beta11. | A relevant emerging alternative, but adopting its derivation/default model would not faithfully preserve Bruvbox's existing six hue families. Revisit as an export when useful. |
| [lush.nvim](https://github.com/rktjmp/lush.nvim) | Lua-based Neovim theme authoring with live feedback and export workflows. | Valuable editor authoring tooling, but makes a Neovim DSL the source of truth. A simple `nvim_set_hl` adapter over shared data fits this task better. |
| [Neovim highlight API](https://neovim.io/doc/user/api/#nvim_set_hl()) | Native highlight groups, links and styles. | Use directly; generated palette/highlight data plus a small runtime with overrides and background selection. |

## Repository findings

Source revision: [`dd115f1133ce40f83711584fad51d83796de6898`](https://github.com/tolgraven/bruvbox/tree/dd115f1133ce40f83711584fad51d83796de6898).

- 79 active literal palette definitions. The surrounding notes contain abandoned color experiments; these are not active palette values and were not imported.
- The 16-color branch mutates cterm indices after loading. The generated Vim function therefore returns a fresh dictionary each time.
- Existing dark `Normal` is light0_soft on dark0. These become the shared canvas roles, preserving the familiar base appearance.
- Existing language mappings contain meaningful distinctions such as special-blue keywords and special-orange functions. Those inform the semantic syntax roles; the modern adapter does not promise identical behavior for every old plugin-specific group.
- tolgrAVen's [`modules/highlight/theme.cljs`](https://github.com/tolgraven/tolgrAVen/blob/master/src/frontend/website/modules/highlight/theme.cljs) duplicates 17 colors, with a source comment pinned to that same Bruvbox revision. The generated CLJC palette preserves all 17 dark values and keys, enabling a small future integration change without replacing its Highlight.js selector map.

## Terminal references

Adapter syntax was checked against [Kitty configuration](https://sw.kovidgoyal.net/kitty/conf/), [Ghostty configuration](https://ghostty.org/docs/config/reference), [Alacritty TOML configuration](https://alacritty.org/config-alacritty.html), and [iTerm2 color presets](https://iterm2.com/documentation-preferences-profiles-colors.html). Native macOS import/render tests are distinct from file/parser checks and remain a consumer validation step.

The generated presets contain real RGB values for ANSI slots; they do not overwrite application-supplied truecolor. A terminal's minimum-contrast setting can intentionally change the displayed colors, as iTerm2's documentation explains.
