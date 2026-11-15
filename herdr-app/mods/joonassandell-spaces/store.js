// Where the avatars are kept, and how an image gets from its file to the screen.
//
// One file holds every choice: ~/.config/herdr-app/joonassandell-spaces-avatars.json. The picker writes it and an
// agent can edit it; the sidebar notices a change within two seconds. The mods keep a copy of it
// in shared state ("joonassandell-spaces.avatars") so every part of the window draws from the same data.
//
//   { "version": 1, "spaces": { "<space name, lowercase>": <avatar> } }
//
//   <avatar> is one of:
//     { "kind": "monogram", "text": "FD", "background": "ansi4", "foreground": "#ffffff" }
//     { "kind": "icon", "icon": "terminal", "background": "ansi3", "foreground": "#ffffff" }
//     { "kind": "image", "source": "/full/path/logo.png", "mode": "reference" }
//     any of them can also have "match": "word", to use it for every space whose name contains the word
//     { "kind": "default" } under a space's own name means "no avatar here", even if a word would match
//
//   "background" and "foreground" are optional. Left out, they are the space's own color and white,
//   as in Herdr. A color is "ansi1" to "ansi6" (Herdr's avatar colors) or "#rrggbb".
//   An image "mode" is "reference" (the file stays where it is) or "copy" (the default).
import { exec, appHome, shared, setShared } from 'herdr';
import { ASSET_DIR, extensionOf, problem, cleanMatch } from './model.js';

const KEY = 'joonassandell-spaces.avatars';
const file = () => `${appHome()}/joonassandell-spaces-avatars.json`;
export const nameKey = (name) => String(name ?? '').trim().toLowerCase();

// The avatar a space shows, or null for the Herdr default.
// 1. An entry under the space's own name wins (a "default" entry means "no avatar").
// 2. Else an entry whose "match" word is in the name. The longest word wins.
export function specFor(map, name) {
  const key = nameKey(name);
  const own = (map ?? {})[key];
  if (own) return own.kind !== 'default' && !problem(own) ? own : null;
  let best = null;
  for (const spec of Object.values(map ?? {})) {
    const word = cleanMatch(spec?.match);
    if (!word || !key.includes(word) || problem(spec) || spec.kind === 'default') continue;
    if (!best || word.length > cleanMatch(best.match).length) best = spec;
  }
  return best;
}

export function allAvatars() {
  return shared(KEY) ?? {};
}

// ---- the file ----

async function readFile() {
  try {
    const r = await exec('cat', [file()]);
    if (r.code !== 0) return {};
    const data = JSON.parse(r.stdout);
    return data && typeof data.spaces === 'object' && data.spaces ? data.spaces : {};
  } catch { return null; } // unreadable: keep what is shown
}

// Copies the file into the shared state when it changed. True if it did.
export async function syncFromFile() {
  const spaces = await readFile();
  if (spaces === null || JSON.stringify(spaces) === JSON.stringify(shared(KEY) ?? {})) return false;
  setShared(KEY, spaces);
  return true;
}

// Saves one space's avatar (null puts the Herdr default back).
export async function saveAvatar(name, spec) {
  const spaces = { ...((await readFile()) ?? shared(KEY) ?? {}) };
  if (spec) spaces[nameKey(name)] = spec;
  else {
    delete spaces[nameKey(name)];
    // Another entry's word would still cover this space, so say "no avatar" explicitly.
    if (specFor(spaces, name)) spaces[nameKey(name)] = { kind: 'default' };
  }
  const text = JSON.stringify({ version: 1, spaces }, null, 2) + '\n';
  // Written in place, so the file can be a symlink (a rename would replace the link).
  // The text goes in as an argument, never into the shell command.
  const r = await exec('sh', ['-c', 'printf %s "$1" > "$2"', 'sh', text, file()]);
  if (r.code !== 0) throw new Error(r.stderr.trim() || 'Could not save the avatar.');
  setShared(KEY, spaces);
}

// ---- images ----
// The picture element only loads files inside the app folder. So an image is brought in there:
// as a copy, or as a link that points at the original ("reference"), which then follows it.

const hash = (text) => { let h = 5381; for (const c of text) h = ((h << 5) + h + c.codePointAt(0)) >>> 0; return h.toString(16); };

export const assetPath = (spec) => {
  const mode = spec.mode === 'reference' ? 'reference' : 'copy';
  return `${ASSET_DIR}/${hash(spec.source)}-${mode}.${extensionOf(spec.source)}`;
};

const ready = new Set(); // assets made in this session
const busy = new Set();

export async function materialize(spec) {
  const path = assetPath(spec);
  const target = `${appHome()}/${path}`;
  // A copy made earlier stays usable if the original is gone.
  if (spec.mode !== 'reference' && (await exec('test', ['-f', target])).code === 0) { ready.add(path); return path; }
  if ((await exec('test', ['-f', spec.source])).code !== 0) throw new Error(`There is no file at ${spec.source}.`);
  await exec('mkdir', ['-p', `${appHome()}/${ASSET_DIR}`]);
  const made = spec.mode === 'reference' ? await exec('ln', ['-sfn', spec.source, target]) : await exec('cp', ['-f', spec.source, target]);
  if (made.code !== 0) throw new Error(made.stderr.trim() || 'Could not use the image.');
  ready.add(path);
  return path;
}

// The path to draw, or null until the asset has been made in this session. Starts making it.
export function ensureAsset(spec) {
  const path = assetPath(spec);
  if (ready.has(path)) return path;
  if (!busy.has(path)) {
    busy.add(path);
    materialize(spec).catch(() => {}).finally(() => { busy.delete(path); setShared('joonassandell-spaces.assets', Date.now()); });
  }
  return null;
}
