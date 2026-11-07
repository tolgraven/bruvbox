import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

export const root = fileURLToPath(new URL('../', import.meta.url));
const namePattern = /^[a-z][a-z0-9-]*$/;
const referencePattern = /^\{([a-z][a-z0-9-]*(?:\.[a-z][a-z0-9-]*)*)\}$/;
const channels = ['foreground', 'background', 'border', 'accent'];
const styles = ['bold', 'italic', 'underline'];
const object = x => x !== null && typeof x === 'object' && !Array.isArray(x);
function assert(ok, message) { if (!ok) throw new Error(message); }
function keys(value, allowed, label) {
  assert(object(value), `${label}: expected object`);
  for (const key of Object.keys(value)) assert(allowed.includes(key), `${label}: unsupported property ${key}`);
}
export function reference(value) {
  const match = typeof value === 'string' && value.match(referencePattern);
  assert(match, `Expected a token reference, got ${JSON.stringify(value)}`);
  return match[1];
}

// Deliberately a strict color/alias subset of DTCG 2025.10, not a general DTCG resolver.
export function flattenTokens(document, prefix = '', inheritedType, result = {}) {
  assert(object(document), `${prefix || 'tokens'}: expected group`);
  if (document.$description !== undefined) assert(typeof document.$description === 'string', `${prefix}: description must be a string`);
  if (document.$extensions !== undefined) assert(object(document.$extensions), `${prefix}: extensions must be an object`);
  if (document.$type !== undefined) assert(document.$type === 'color', `${prefix}: only color tokens are supported`);
  if (Object.hasOwn(document, '$value')) {
    assert(prefix, 'Token document root must be a group');
    keys(document, ['$type', '$value', '$description', '$extensions'], prefix);
    assert((document.$type ?? inheritedType) === 'color', `${prefix}: only color tokens are supported`);
    assert(!Object.hasOwn(result, prefix), `Duplicate token ${prefix}`);
    result[prefix] = document;
    return result;
  }
  for (const [key, value] of Object.entries(document)) {
    if (key.startsWith('$')) {
      assert(['$type', '$description', '$extensions'].includes(key), `${prefix}: unsupported group property ${key}`);
      continue;
    }
    assert(namePattern.test(key), `Invalid token/group name ${key}`);
    flattenTokens(value, prefix ? `${prefix}.${key}` : key, document.$type ?? inheritedType, result);
  }
  return result;
}
function colorHex(value, label) {
  keys(value, ['colorSpace', 'components', 'alpha', 'hex'], label);
  assert(value.colorSpace === 'srgb', `${label}: only sRGB is supported`);
  assert(value.alpha === undefined || value.alpha === 1, `${label}: only opaque colors are supported`);
  assert(Array.isArray(value.components) && value.components.length === 3 && value.components.every(v => typeof v === 'number' && Number.isFinite(v) && v >= 0 && v <= 1), `${label}: invalid sRGB components`);
  const hex = '#' + value.components.map(v => Math.round(v * 255).toString(16).padStart(2, '0')).join('');
  assert(value.hex === undefined || (typeof value.hex === 'string' && value.hex.toLowerCase() === hex), `${label}: hex disagrees with components`);
  return hex;
}
export function resolveTokens(tokens) {
  const resolved = {}, visiting = new Set();
  function resolve(name) {
    assert(Object.hasOwn(tokens, name), `Unknown token ${name}`);
    if (Object.hasOwn(resolved, name)) return resolved[name];
    assert(!visiting.has(name), `Token alias cycle at ${name}`);
    visiting.add(name);
    const value = tokens[name].$value;
    resolved[name] = typeof value === 'string' ? resolve(reference(value)) : colorHex(value, name);
    visiting.delete(name);
    return resolved[name];
  }
  Object.keys(tokens).sort().forEach(resolve);
  const identifiers = new Set();
  for (const name of Object.keys(resolved)) {
    const id = cssName(name);
    assert(!identifiers.has(id), `Flattened CSS/Sass name collision: ${name}`);
    identifiers.add(id);
  }
  return resolved;
}
export const cssName = name => name.replaceAll('.', '-');
export function contrast(foreground, background) {
  const luminance = hex => {
    const c = [1, 3, 5].map(i => parseInt(hex.slice(i, i + 2), 16) / 255).map(c => c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4);
    return c[0] * 0.2126 + c[1] * 0.7152 + c[2] * 0.0722;
  };
  const [a, b] = [luminance(foreground), luminance(background)].sort((a, b) => b - a);
  return (a + 0.05) / (b + 0.05);
}
export function resolveCombinations(definitions, colors) {
  assert(object(definitions), 'combinations: expected object');
  const references = {}, resolved = {}, visiting = new Set();
  function resolve(name) {
    assert(Object.hasOwn(definitions, name), `Unknown combination ${name}`);
    if (Object.hasOwn(resolved, name)) return resolved[name];
    assert(namePattern.test(name), `Invalid combination name ${name}`);
    assert(!visiting.has(name), `Combination cycle at ${name}`);
    visiting.add(name);
    const own = definitions[name];
    keys(own, [...channels, ...styles, 'extends', 'minContrast'], `combination ${name}`);
    if (own.extends !== undefined) {
      assert(typeof own.extends === 'string', `${name}: extends must be a name`);
      resolve(own.extends);
    }
    const spec = { ...(own.extends ? references[own.extends] : {}), ...own };
    delete spec.extends;
    assert(spec.foreground && spec.background, `${name}: foreground and background are required`);
    const out = {};
    for (const channel of channels) if (spec[channel] !== undefined) {
      const token = reference(spec[channel]);
      assert(Object.hasOwn(colors, token), `${name}: unknown token ${token}`);
      out[channel] = colors[token];
    }
    for (const style of styles) if (spec[style] !== undefined) {
      assert(typeof spec[style] === 'boolean', `${name}: ${style} must be boolean`);
      out[style] = spec[style];
    }
    const rawContrast = contrast(out.foreground, out.background);
    // Math.pow may differ in its last bits between V8 releases/architectures.
    // Serialize a stable precision, but enforce requirements on the raw ratio.
    out.contrast = Number(rawContrast.toFixed(6));
    if (spec.minContrast !== undefined) {
      assert(typeof spec.minContrast === 'number' && Number.isFinite(spec.minContrast) && spec.minContrast >= 1 && spec.minContrast <= 21, `${name}: invalid minimum contrast`);
      assert(rawContrast >= spec.minContrast, `${name}: contrast ${out.contrast.toFixed(2)} is below ${spec.minContrast}`);
      out.minContrast = spec.minContrast;
    }
    references[name] = spec;
    resolved[name] = out;
    visiting.delete(name);
    return out;
  }
  Object.keys(definitions).sort().forEach(resolve);
  return { combinations: resolved, combinationReferences: references };
}
export function validateManifest(manifest) {
  keys(manifest, ['$schema', 'schemaVersion', 'name', 'palette', 'variants', 'combinations'], 'theme');
  assert(manifest.schemaVersion === 1, 'Unsupported schemaVersion');
  assert(typeof manifest.name === 'string' && namePattern.test(manifest.name), 'Invalid theme name');
  assert(object(manifest.variants) && Object.keys(manifest.variants).length, 'variants must not be empty');
  const files = [manifest.palette, ...Object.values(manifest.variants)];
  assert(files.every(f => typeof f === 'string' && !path.isAbsolute(f) && !f.split(/[\\/]/).includes('..') && f.endsWith('.tokens.json')), 'Token paths must be relative .tokens.json files inside the theme directory');
  for (const variant of Object.keys(manifest.variants)) assert(namePattern.test(variant), `Invalid variant ${variant}`);
  assert(object(manifest.combinations), 'combinations must be an object');
}
export async function loadTheme(directory = root) {
  const read = async file => JSON.parse(await readFile(path.join(directory, file), 'utf8'));
  const manifest = await read('theme.json');
  validateManifest(manifest);
  const paletteDocument = await read(manifest.palette);
  const paletteTokens = flattenTokens(paletteDocument);
  const variants = {};
  for (const [name, file] of Object.entries(manifest.variants)) {
    const document = await read(file);
    const tokens = flattenTokens(document, '', undefined, { ...paletteTokens });
    const colors = resolveTokens(tokens);
    // Adapter-independent API, no Vim names required by consumers.
    variants[name] = { colors, tokens, ...resolveCombinations(manifest.combinations, colors) };
  }
  return { manifest, paletteTokens, paletteDocument, variants };
}
export function getColor(theme, name, variant = 'dark') {
  const value = theme.variants[variant]?.colors[name];
  assert(value, `Unknown color ${variant}:${name}`);
  return value;
}
export function getCombination(theme, name, variant = 'dark') {
  const value = theme.variants[variant]?.combinations[name];
  assert(value, `Unknown combination ${variant}:${name}`);
  return { ...value };
}
