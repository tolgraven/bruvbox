# Portable theme schema v1

## Layers and resolution

1. A `theme.json` manifest selects one palette token document and one semantic token document per variant. Files are merged at flattened token paths; duplicate definitions fail rather than silently overwriting. Every variant resolves independently.
2. DTCG color tokens encode concrete sRGB values or `{path.to.token}` aliases. Names use lower-case ASCII letters, digits and hyphens; dots delimit paths. `$type: "color"` can be inherited from a group. `$description` and `$extensions` preserve metadata. `$value` identifies a token.
3. Combinations declare a foreground and background, optional border/accent, and optional bold/italic/underline intent. Every color channel references a token. `extends` inherits another named combination; explicit fields replace inherited fields. Cycles, missing parents and missing channels fail.
4. Adapters assign meaning to target-specific slots/highlights. The resolver knows nothing about Vim, CSS selectors or a particular terminal.

The manifest's composition mechanism is **Bruvbox v1**, not an implementation of the DTCG Resolver module. The token format is a strict subset of the stable DTCG 2025.10 Format/Color modules. P3, OKLCH, alpha other than 1, component references, `$ref`, `$extends`, composite token types and calculations are unsupported and rejected. sRGB components are authoritative; an optional hex convenience field must match 8-bit rounding. Output colors are quantized to 8-bit RGB for target parity. Current palette values are exact 8-bit colors, so no precision is lost on migration.

## A combination

```json
{
  "error": {
    "foreground": "{accent.red}",
    "background": "{tint.red}",
    "border": "{accent.red}"
  },
  "error-emphasis": {
    "extends": "error",
    "bold": true,
    "minContrast": 4.5
  }
}
```

A combination is a named relationship, not a component or CSS rule. Web may use it for a notice; Neovim may map it to diagnostic virtual text. Border is a color only: the consuming UI decides border width/style. Neovim uses foreground/background/style, since a text highlight has no CSS-like border. Specific target mappings stay outside this model.

Treat interaction states as explicit combination names, e.g. `button`, `button-hover`, `button-disabled`. Applications own state transitions; the schema does not assume DOM pseudo-classes, editor modes, widget hierarchies or an event model.

## New variants and consumers

A variant token document supplies the same semantic paths and aliases different palette entries. The core loader accepts arbitrary variant names; shipped adapters currently assume `dark`/`light` (CSS defaults, Sass defaults, Neovim config and Base16 variant values). To ship a third mode, update those adapter policies and tests explicitly. This is intentional, not automatic full multi-theme support.

A new adapter consumes `loadTheme()` and uses resolved `colors` and `combinations`. Put target mappings into `adapters/`, keep literal colors in the palette, and add output verification. Exported JSON is the easiest interface from Python, Clojure, shell tools or a browser. Exported DTCG JSON is preferable for design-token tools; it includes palette, semantics and combination color groups, with no external aliases. Non-color combination styles and contrast requirements remain in the manifest/resolved JSON rather than being presented as invented standard token types.

## Validation and compatibility

- `schema/theme.schema.json` describes the composition format. `schema/tokens.schema.json` describes the supported token subset, not every feature of DTCG.
- The dependency-free runtime validates references, supported fields/types, color consistency, output name collisions and requirements. Development tests also validate source documents with Ajv.
- Errors abort generation before any artifact is written. Writers never delete unknown files. Remove obsolete generated artifacts explicitly after review.
- The generated legacy Vim palette returns a fresh dictionary, preserving the original cterm indices. Original indices are historical metadata, not newly calculated nearest-color approximations.
- `schemaVersion` changes for incompatible manifest structure. Renaming/removing public semantic paths or changing combination intent should be treated as a breaking API change even when the schema itself is unchanged. Pin consumer submodules to reviewed commits.
- Raw palette names intentionally retain original distinctions (`bright`, `neutral`, `faded`, `special`, `bg-dark`, `bg-light`) rather than guessing a perceptually uniform scale. Prefer semantic paths in application code.

## Contrast

Contrast uses WCAG relative luminance on the resolved opaque sRGB colors. It does not assess borders, non-text graphics, font size, antialiasing, transparent composition, or an entire UI. `normalTextAA` means ratio ≥ 4.5; `largeTextAA` means ratio ≥ 3. These labels are numeric checks, not universal accessibility certification. Resolved ratios are serialized to six decimal places for reproducibility across JavaScript engines (the compact report uses three); requirements are checked against the unrounded calculation. Only an explicit `minContrast` requirement blocks a build.

The default canvas requires 4.5 in both variants. The preserved dark muted pair is about 4.31. Several inherited light colored combinations fall below 4.5; see `dist/contrast.json` before choosing them for body text. A future accessible variant can point roles at alternative palette entries without altering the legacy variant.
