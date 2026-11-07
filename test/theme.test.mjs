import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { execFileSync } from 'node:child_process';
import { tmpdir } from 'node:os';
import path from 'node:path';
import Ajv from 'ajv';
import * as sass from 'sass';
import { flattenTokens, resolveTokens, resolveCombinations, loadTheme, getColor, getCombination, contrast, root, validateManifest } from '../src/theme.mjs';
import { renderCSS, renderSCSS, renderTerminals, highlights } from '../src/render.mjs';
const read = async file => JSON.parse(await readFile(path.join(root,file),'utf8'));
const theme = await loadTheme();
const color = hex => ({$type:'color',$value:{colorSpace:'srgb',components:[1,3,5].map(i=>parseInt(hex.slice(i,i+2),16)/255),hex}});
const alias = ref => ({$type:'color',$value:`{${ref}}`});

test('authoring documents validate against the published local schemas', async () => {
  const ajv = new Ajv({strict:false});
  const validate = ajv.compile(await read('schema/theme.schema.json'));
  assert.ok(validate(theme.manifest),JSON.stringify(validate.errors));
  const tokens = ajv.compile(await read('schema/tokens.schema.json'));
  for(const file of [theme.manifest.palette,...Object.values(theme.manifest.variants)]) assert.ok(tokens(await read(file)),JSON.stringify(tokens.errors));
});
test('palette migration preserves the complete original set, including cterm metadata', async () => {
  const {createHash}=await import('node:crypto');
  const triples = Object.entries(theme.paletteTokens).map(([key,t])=>[t.$extensions['se.tolgraven.bruvbox'].legacyName,theme.variants.dark.colors[key],t.$extensions['se.tolgraven.bruvbox'].cterm]).sort(([a],[b])=>a<b?-1:a>b?1:0);
  assert.equal(triples.length,79);
  assert.equal(createHash('sha256').update(JSON.stringify(triples)).digest('hex'),'fc0f95ab6fb6f8a55d55b5f683776df686f128beee49f58c7e93498233d07945');
});
test('dark and light semantic roles resolve, public lookups reject typos', () => {
  assert.equal(getColor(theme,'surface.canvas'),'#262525');
  assert.equal(getColor(theme,'surface.canvas','light'),'#faecc9');
  assert.equal(getColor(theme,'syntax.function'),'#dba184');
  assert.equal(getCombination(theme,'error').foreground,'#d18479');
  assert.throws(()=>getColor(theme,'unknown'),/Unknown color/);
  assert.throws(()=>getCombination(theme,'error','unknown'),/Unknown combination/);
  const copy=getCombination(theme,'error');copy.foreground='#ffffff';
  assert.equal(getCombination(theme,'error').foreground,'#d18479');
});
test('aliases, inherited types, unsupported types, missing refs and cycles', () => {
  assert.equal(resolveTokens(flattenTokens({$type:'color',a:{$value:color('#123456').$value},b:alias('a')})).b,'#123456');
  assert.throws(()=>resolveTokens({a:alias('missing')}),/Unknown token/);
  assert.throws(()=>resolveTokens({a:alias('b'),b:alias('a')}),/cycle/);
  assert.throws(()=>flattenTokens({a:{$type:'dimension',$value:5}}),/only color/);
  assert.throws(()=>flattenTokens({$extends:'base'}),/unsupported/);
  assert.throws(()=>flattenTokens({'bad.name':color('#ffffff')}),/Invalid/);
  assert.throws(()=>flattenTokens({a:color('#ffffff')},'',undefined,{a:color('#000000')}),/Duplicate/);
  assert.throws(()=>resolveTokens({'a.b':color('#ffffff'),'a-b':color('#000000')}),/collision/);
});
test('color validation rejects unsupported spaces, alpha and inconsistent hex', () => {
  for(const patch of [{colorSpace:'oklch'},{alpha:0.5},{components:[2,0,0]},{hex:'#000000'}]) {
    assert.throws(()=>resolveTokens({a:{$type:'color',$value:{...color('#ffffff').$value,...patch}}}));
  }
});
test('combinations inherit, allow overrides and detect invalid graphs and contrast', () => {
  const colors={black:'#000000',white:'#ffffff'};
  const combos={base:{foreground:'{white}',background:'{black}',bold:true},child:{extends:'base',bold:false}};
  const r=resolveCombinations(combos,colors).combinations;
  assert.equal(r.child.contrast,21);assert.equal(r.child.bold,false);
  assert.throws(()=>resolveCombinations({a:{extends:'b'},b:{extends:'a'}},colors),/cycle/);
  assert.throws(()=>resolveCombinations({a:{extends:'nope'}},colors),/Unknown combination/);
  assert.throws(()=>resolveCombinations({a:{foreground:'{white}',background:'{white}',minContrast:4.5}},colors),/below/);
  assert.throws(()=>resolveCombinations({a:{foreground:'#ffffff',background:'{white}'}},colors),/reference/);
  assert.throws(()=>resolveCombinations({a:{foreground:'{white}',background:'{black}',blink:true}},colors),/unsupported/);
  assert.equal(contrast('#000000','#ffffff'),21);assert.equal(contrast('#ffffff','#ffffff'),1);
});
test('manifest rejects future versions and escaping token paths',()=>{
  assert.throws(()=>validateManifest({...theme.manifest,schemaVersion:2}),/schemaVersion/);
  assert.throws(()=>validateManifest({...theme.manifest,palette:'../other.tokens.json'}),/relative/);
});
test('Sass compiles literal and runtime variables, combinations and errors',()=>{
  const source=renderSCSS(theme);
  const result=sass.compileString(source+'\n.test { color: color("accent.orange", "light"); background: $bruvbox-surface-canvas; outline-color: css-color("accent.blue"); @include combination("error"); }\n.fixed { @include combination("button", "light"); }').css;
  assert.match(result,/#99613c/); assert.match(result,/#262525/);assert.match(result,/var\(--bruvbox-accent-blue\)/);assert.match(result,/var\(--bruvbox-combination-error-foreground\)/);
  assert.match(result,/font-weight: bold/);
  assert.throws(()=>sass.compileString(source+'\n.test { color: color("typo"); }'),/Unknown Bruvbox/);
});
test('terminal formats share all sixteen slots and highlight links are valid',async()=>{
  const adapter=await read('adapters/nvim.json'); const base16=await read('adapters/base16.json');
  for(const [name,v] of Object.entries(theme.variants)) {
    const files=renderTerminals(v,name,base16);
    const kitty=files[`dist/kitty/bruvbox-${name}.conf`],ghostty=files[`dist/ghostty/bruvbox-${name}`];
    for(let i=0;i<16;i++) {assert.ok(kitty.includes(`color${i} ${v.colors[`terminal.ansi-${i}`]}\n`));assert.ok(ghostty.includes(`palette = ${i}=${v.colors[`terminal.ansi-${i}`]}\n`));}
    assert.equal(highlights(v,adapter).Normal.bg,v.colors['surface.canvas']);
  }
  assert.throws(()=>highlights(theme.variants.dark,{A:{link:'B'},B:{link:'A'}}),/cycle/);
  assert.throws(()=>highlights(theme.variants.dark,{A:{fg:'missing'}}),/Unknown/);
  assert.match(renderCSS(theme),/data-bruvbox="light"/);
});
test('standalone DTCG exports resolve without external files',async()=>{
  for(const name of ['dark','light']) {
    const resolved=resolveTokens(flattenTokens(await read(`dist/dtcg/bruvbox-${name}.tokens.json`)));
    assert.equal(resolved['combination.error.foreground'],theme.variants[name].combinations.error.foreground);
  }
});
test('generation is deterministic, check detects stale and obsolete files, custom output is cwd-independent',async()=>{
  const dir=await mkdtemp(path.join(tmpdir(),'bruvbox-test-'));
  try {
    const run=(...args)=>execFileSync(process.execPath,[path.join(root,'scripts/build.mjs'),'--out',dir,...args],{cwd:tmpdir(),stdio:'pipe'});
    run();run('--check');
    await writeFile(path.join(dir,'dist/web/bruvbox.css'),'stale');
    assert.throws(()=>run('--check'),/out of date/);
    run(); await writeFile(path.join(dir,'dist/obsolete.txt'),'old');
    assert.throws(()=>run('--check'),/Unrecognized/);
  } finally {await rm(dir,{recursive:true,force:true});}
});
test('tolgrAVen Highlight.js palette adapter preserves every existing dark value',async()=>{
  const mapping=await read('adapters/highlight-palette.json');
  const expected={background:'#262525',foreground:'#f0e3ba',symbol:'#faecc9',identifier:'#d5c4a1',comment:'#908682',red:'#d18479',green:'#b4b88d',yellow:'#dabd7a',type:'#d9c894',blue:'#7692ab',keyword:'#80a0b3',purple:'#bd979d',aqua:'#91b8a4',orange:'#cca687',function:'#dba184',addition:'#1f281c',deletion:'#281913'};
  assert.deepEqual(Object.fromEntries(Object.entries(mapping).map(([k,token])=>[k,getColor(theme,token)])),expected);
});
