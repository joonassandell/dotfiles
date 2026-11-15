// Plain data and helpers shared by the sidebar, the menu and the picker.
export const MOD = 'joonassandell-spaces';
export const ASSET_DIR = 'assets/joonassandell-spaces';

// The colors Herdr's own avatars use (one strong color per hue, light and dark alike).
// They are stored by name, so an avatar keeps following Herdr's palette.
export const MARK = { ansi6: '#22a99a', ansi3: '#e3814f', ansi4: '#5b8def', ansi5: '#8b7cf6', ansi2: '#3fae6a', ansi1: '#d9649a' };
export const HUES = ['ansi6', 'ansi3', 'ansi4', 'ansi5', 'ansi2', 'ansi1'];
export const WHITE = '#ffffff';
export const DARK = '#18181b';
export const INHERITED_TEXT = WHITE;

export const POPULAR = ['folder-code', 'code', 'terminal', 'globe', 'server', 'database', 'bot', 'sparkles', 'smartphone', 'monitor', 'cloud-cog', 'package', 'book-open', 'flask-conical', 'shield-check', 'rocket', 'gamepad-2', 'music', 'image', 'shopping-bag', 'git-branch', 'workflow', 'wrench', 'layers', 'heart', 'star', 'coffee', 'paw-print', 'leaf', 'gem'];
export const IMAGE_EXTENSIONS = ['png', 'jpg', 'jpeg', 'svg', 'gif', 'webp'];

const words = (name) => String(name ?? '').normalize('NFKC').split(/[^\p{L}\p{N}]+/u).filter(Boolean);

// What Herdr shows by default: the first letter.
export function firstLetter(name) {
  return [...String(name ?? '')][0]?.toUpperCase() ?? '?';
}

// The first letters of the first two words: "Freepress Docs" is "FD".
export function initials(name) {
  const w = words(name);
  if (!w.length) return '?';
  return w.slice(0, 2).map((x) => [...x][0]).join('').toUpperCase();
}

export function cleanLetters(text) {
  return [...String(text ?? '').normalize('NFKC').replace(/\s+/g, '').toUpperCase()].slice(0, 2).join('');
}

export const validLetters = (text) => /^[\p{L}\p{N}]{1,2}$/u.test(cleanLetters(text));
export const validIcon = (name) => /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(name ?? '');
export const cleanMatch = (text) => String(text ?? '').normalize('NFKC').trim().toLowerCase();
export const validColor = (c) => c === undefined || c === null || /^#[a-f0-9]{6}$/i.test(c) || HUES.includes(c);
export const extensionOf = (path) => (String(path).match(/\.([a-z0-9]+)$/i)?.[1] ?? '').toLowerCase();
export const baseName = (path) => String(path).replace(/\/+$/, '').split('/').pop();

// Why a saved or drafted avatar can't be used, or null.
export function problem(spec) {
  if (!spec || spec.kind === 'default') return null;
  if (!['monogram', 'icon', 'image'].includes(spec.kind)) return 'Choose an avatar type.';
  if (spec.match !== undefined && (typeof spec.match !== 'string' || spec.match.length > 80)) return 'Use a short word to match.';
  if (!validColor(spec.background) || !validColor(spec.foreground)) return 'Use one of the listed colors.';
  if (spec.kind === 'monogram' && !validLetters(spec.text)) return 'Use max 2 letters or numbers';
  if (spec.kind === 'icon' && !validIcon(spec.icon)) return 'Choose an icon.';
  if (spec.kind === 'image') {
    if (!spec.source) return 'Choose an image.';
    if (!IMAGE_EXTENSIONS.includes(extensionOf(spec.source))) return `Use a ${IMAGE_EXTENSIONS.join(', ')} file.`;
    if (!String(spec.source).startsWith('/')) return 'Use the full path of the image.';
  }
  return null;
}

export function filterIcons(names, query) {
  const needle = String(query).trim().toLowerCase().replace(/\s+/g, '-');
  return needle ? names.filter((name) => name.includes(needle)) : POPULAR.filter((name) => names.includes(name));
}
