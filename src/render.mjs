import { cssName, reference, resolveTokens } from './theme.mjs';
const header = 'Generated from Bruvbox tokens. Do not edit.';
const sorted = object => Object.entries(object).sort(([a], [b]) => a.localeCompare(b, 'en'));
const colorChannels = ['foreground', 'background', 'border', 'accent'];
const quote = JSON.stringify;
const variable = name => `--bruvbox-${cssName(name)}`;
export function webValues(variant) {
  const values = { ...variant.colors };
  for (const [name, combo] of sorted(variant.combinations)) for (const channel of colorChannels) {
    if (combo[channel]) {
      const key = `combination.${name}.${channel}`;
      if (Object.keys(values).some(k => cssName(k) === cssName(key))) throw new Error(`Combination CSS name collision: ${key}`);
      values[key] = combo[channel];
    }
  }
  return values;
}
export function renderCSS(theme) {
  return `/* ${header} */\n` + sorted(theme.variants).map(([name, v]) => {
    const values = webValues(v);
    const refs = Object.fromEntries(Object.entries(v.tokens).filter(([, t]) => typeof t.$value === 'string').map(([key, t]) => [key, reference(t.$value)]));
    for (const [combo, spec] of sorted(v.combinationReferences)) for (const channel of colorChannels) if (spec[channel]) refs[`combination.${combo}.${channel}`] = reference(spec[channel]);
    const selector = name === 'dark' ? ':root,\n[data-bruvbox="dark"]' : `[data-bruvbox="${name}"]`;
    return `${selector} {\n` + sorted(values).map(([key, value]) => `  ${variable(key)}: ${refs[key] ? `var(${variable(refs[key])})` : value};`).join('\n') + '\n}\n';
  }).join('\n');
}
export function renderSCSS(theme) {
  const defaults = theme.variants.dark ?? Object.values(theme.variants)[0];
  let s = `// ${header}\n@use "sass:map";\n\n`;
  s += sorted(webValues(defaults)).map(([name, value]) => `$bruvbox-${cssName(name)}: ${value};`).join('\n');
  s += '\n\n$themes: (\n' + sorted(theme.variants).map(([name, v]) => `  ${quote(name)}: (\n` + sorted(webValues(v)).map(([k, value]) => `    ${quote(k)}: ${value},`).join('\n') + '\n  ),').join('\n') + '\n);\n';
  s += '\n$combinations: (\n' + sorted(theme.variants).map(([name,v]) => `  ${quote(name)}: (\n` + sorted(v.combinations).map(([key,c]) => `    ${quote(key)}: (` + Object.entries(c).filter(([k]) => [...colorChannels,'bold','italic','underline'].includes(k)).map(([k,val]) => `${quote(k)}: ${val}`).join(', ') + '),').join('\n') + '\n  ),').join('\n') + '\n);\n';
  s += `
@function color($name, $variant: "dark") {
  @if not map.has-key($themes, $variant, $name) { @error "Unknown Bruvbox color: #{$variant}:#{$name}"; }
  @return map.get($themes, $variant, $name);
}
@function css-color($name) {
  @if not map.has-key($themes, "dark", $name) { @error "Unknown Bruvbox color: #{$name}"; }
  @return var(--bruvbox-#{map.get($css-names, $name)});
}
@mixin combination($name, $variant: null) {
  $lookup: "dark";
  @if $variant != null { $lookup: $variant; }
  @if not map.has-key($combinations, $lookup, $name) { @error "Unknown Bruvbox combination: #{$lookup}:#{$name}"; }
  $combo: map.get($combinations, $lookup, $name);
  @each $channel, $property in ("foreground": color, "background": background-color, "border": border-color, "accent": accent-color) {
    @if map.has-key($combo, $channel) {
      @if $variant == null { #{$property}: var(--bruvbox-combination-#{$name}-#{$channel}); }
      @else { #{$property}: map.get($combo, $channel); }
    }
  }
  @if map.has-key($combo, "bold") {
    @if map.get($combo, "bold") { font-weight: bold; } @else { font-weight: normal; }
  }
  @if map.has-key($combo, "italic") {
    @if map.get($combo, "italic") { font-style: italic; } @else { font-style: normal; }
  }
  @if map.has-key($combo, "underline") {
    @if map.get($combo, "underline") { text-decoration: underline; } @else { text-decoration: none; }
  }
}
`;
  s += '\n$css-names: (\n' + sorted(webValues(defaults)).map(([name]) => `  ${quote(name)}: ${quote(cssName(name))},`).join('\n') + '\n);\n';
  return s;
}
export function toLua(value) {
  if (value === null) return 'nil';
  if (typeof value !== 'object') return JSON.stringify(value);
  return '{\n' + Object.entries(value).map(([k, v]) => `[${quote(k)}] = ${toLua(v)},`).join('\n') + '\n}';
}
export function highlights(variant, adapter) {
  const result = {};
  for (const [name, spec] of Object.entries(adapter)) {
    const out = {};
    for (const key of Object.keys(spec)) if (!['combination','fg','bg','sp','link','bold','italic','underline','undercurl','strikethrough'].includes(key)) throw new Error(`${name}: unknown highlight property ${key}`);
    if (spec.link) {
      if (Object.keys(spec).length !== 1 || !Object.hasOwn(adapter, spec.link)) throw new Error(`${name}: invalid link ${spec.link}`);
      result[name] = {link:spec.link}; continue;
    }
    if (spec.combination) {
      const combo = variant.combinations[spec.combination];
      if (!combo) throw new Error(`Unknown combination ${spec.combination}`);
      out.fg = combo.foreground; out.bg = combo.background;
      for (const style of ['bold','italic','underline']) if (combo[style] !== undefined) out[style] = combo[style];
    }
    for (const key of ['fg','bg','sp']) if (spec[key]) {
      if (!Object.hasOwn(variant.colors, spec[key])) throw new Error(`Unknown highlight color ${spec[key]}`);
      out[key] = variant.colors[spec[key]];
    }
    for (const key of ['bold','italic','underline','undercurl','strikethrough']) if (spec[key] !== undefined) {
      if (typeof spec[key] !== 'boolean') throw new Error(`${name}: ${key} must be boolean`);
      out[key] = spec[key];
    }
    result[name] = out;
  }
  for (const name of Object.keys(result)) {
    const seen = new Set(); let cursor = name;
    while (result[cursor]?.link) {
      if (seen.has(cursor)) throw new Error(`Highlight link cycle at ${cursor}`);
      seen.add(cursor); cursor = result[cursor].link;
    }
  }
  return result;
}
export function renderLegacy(theme) {
  const colors = resolveTokens(theme.paletteTokens);
  const names = new Set();
  const entries = sorted(theme.paletteTokens).map(([key,t]) => {
    const meta = t.$extensions?.['se.tolgraven.bruvbox'];
    if (!meta || !/^[a-z][a-z0-9_]*$/.test(meta.legacyName) || !Number.isInteger(meta.cterm) || meta.cterm < 0 || meta.cterm > 255) throw new Error(`Invalid legacy palette metadata: ${key}`);
    if (names.has(meta.legacyName)) throw new Error(`Duplicate legacy palette name: ${meta.legacyName}`);
    names.add(meta.legacyName);
    return `        \\ '${meta.legacyName}': ['${colors[key]}', ${meta.cterm}],`;
  });
  return `" ${header}\nfunction! bruvbox#palette#get() abort\n  return {\n${entries.join('\n')}\n        \\ }\nendfunction\n`;
}
export function renderTerminals(variant, name, base16) {
  const c = key => { if (!Object.hasOwn(variant.colors,key)) throw new Error(`Missing terminal token ${key}`); return variant.colors[key]; };
  const ansi = Array.from({length:16}, (_, i) => c(`terminal.ansi-${i}`));
  const background=c('surface.canvas'), foreground=c('text.primary'), selection=variant.combinations.selection;
  const names=['black','red','green','yellow','blue','magenta','cyan','white'];
  const kitty = `# ${header}\nbackground ${background}\nforeground ${foreground}\ncursor ${foreground}\ncursor_text_color ${background}\nselection_background ${selection.background}\nselection_foreground ${selection.foreground}\n` + ansi.map((v,i)=>`color${i} ${v}`).join('\n')+'\n';
  const ghostty = `# ${header}\nbackground = ${background}\nforeground = ${foreground}\ncursor-color = ${foreground}\ncursor-text = ${background}\nselection-background = ${selection.background}\nselection-foreground = ${selection.foreground}\n` + ansi.map((v,i)=>`palette = ${i}=${v}`).join('\n')+'\n';
  const alacritty = `# ${header}\n[colors.primary]\nbackground = "${background}"\nforeground = "${foreground}"\n[colors.cursor]\ncursor = "${foreground}"\ntext = "${background}"\n[colors.selection]\nbackground = "${selection.background}"\ntext = "${selection.foreground}"\n` + ['normal','bright'].map((group,g)=>`[colors.${group}]\n`+names.map((key,i)=>`${key} = "${ansi[g*8+i]}"`).join('\n')).join('\n')+'\n';
  const itermColors = Object.fromEntries(ansi.map((v,i)=>[`Ansi ${i} Color`,v]));
  Object.assign(itermColors, {'Background Color':background,'Foreground Color':foreground,'Cursor Color':foreground,'Cursor Text Color':background,'Selection Color':selection.background,'Selected Text Color':selection.foreground});
  const iterm = `<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0"><dict>\n` + sorted(itermColors).map(([key,hex])=>`<key>${key}</key><dict><key>Color Space</key><string>sRGB</string>`+['Red','Green','Blue'].map((channel,i)=>`<key>${channel} Component</key><real>${parseInt(hex.slice(1+i*2,3+i*2),16)/255}</real>`).join('')+'</dict>').join('\n')+'\n</dict></plist>\n';
  const yaml = `# ${header}\n# Lossy projection: rich combinations remain in theme.json.\nsystem: base16\nname: Bruvbox ${name}\nauthor: Joen Tolgraven (derived from morhetz/gruvbox)\nvariant: ${name}\npalette:\n`+sorted(base16).map(([key,token])=>`  ${key}: "${c(token).slice(1)}"`).join('\n')+'\n';
  return { [`dist/kitty/bruvbox-${name}.conf`]:kitty, [`dist/ghostty/bruvbox-${name}`]:ghostty, [`dist/alacritty/bruvbox-${name}.toml`]:alacritty, [`dist/iterm/bruvbox-${name}.itermcolors`]:iterm, [`dist/base16/bruvbox-${name}.yaml`]:yaml };
}
export function renderPreview(theme) {
  const esc = s => String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const sections = sorted(theme.variants).map(([name,v])=>`<section data-bruvbox="${name}"><h2>${esc(name)}</h2><div class="grid">`+sorted(v.combinations).map(([key,c])=>`<article style="color:${c.foreground};background:${c.background};border-color:${c.border??c.background}"><h3>${esc(key)}</h3><p>The quick brown fox<br>λ → (map inc [1 2 3])</p><small>${c.foreground} / ${c.background}<br>${c.contrast.toFixed(2)}:1 · ${c.contrast>=4.5?'AA normal text':c.contrast>=3?'AA large text only':'below AA text'}</small></article>`).join('')+'</div><h3>Palette & semantic tokens</h3><div class="swatches">'+sorted(v.colors).map(([key,color])=>`<div><i style="background:${color}"></i><code>${esc(key)}<br>${color}</code></div>`).join('')+'</div></section>').join('');
  return `<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Bruvbox — palette & combinations</title><style>${renderCSS(theme)}
*{box-sizing:border-box}body{margin:0;background:var(--bruvbox-surface-canvas);color:var(--bruvbox-text-primary);font:15px/1.6 ui-monospace,monospace}header,section{padding:clamp(18px,4vw,60px)}header{border-bottom:1px solid var(--bruvbox-border-default)}h1{font-size:clamp(32px,6vw,64px);margin:0;letter-spacing:-.06em}h2{text-transform:uppercase;letter-spacing:.2em}h3{margin:0 0 8px}section{background:var(--bruvbox-surface-canvas);color:var(--bruvbox-text-primary)}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:12px}article{padding:20px;border:1px solid;border-radius:6px}small{font-size:12px}.swatches{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:10px;margin-top:20px}.swatches>div{display:flex;gap:12px;align-items:center}i{display:block;width:32px;height:32px;border:1px solid var(--bruvbox-border-default);flex-shrink:0}code{font-size:12px;overflow-wrap:anywhere}</style><header><p>BRUVBOX / DESIGN SOURCE</p><h1>Faded colors. Defined relationships.</h1><p>Exact legacy palette · semantic roles · reusable combinations</p><p>Contrast is measured for opaque sRGB foreground/background pairs. Ratios describe text, not a blanket accessibility guarantee.</p></header>${sections}</html>\n`;
}
