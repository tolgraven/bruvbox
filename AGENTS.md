# Bruvbox

- `tokens/*.tokens.json` owns colors and semantic aliases; `theme.json` owns combinations and variant composition. Do not hand-edit generated outputs.
- This implements the documented opaque sRGB + whole-token-alias subset of DTCG 2025.10. Unsupported features must fail explicitly.
- `src/theme.mjs` is target independent. Application mappings belong in `adapters/` or runtime adapters, never in palette tokens.
- Run `npm test`, `npm run build`, and `npm run check`. Commit generated `dist/`, `lua/bruvbox/generated.lua` and `autoload/bruvbox/palette.vim` with their inputs.
- Keep the original Vim theme working. The Lua replacement is opt-in (`bruvbox-next`) during migration; no implicit switch of existing installs.
- Preserve palette provenance and Gruvbox attribution. Do not silently alter colors to satisfy contrast checks; report ratios and use explicit requirements for new combinations.
