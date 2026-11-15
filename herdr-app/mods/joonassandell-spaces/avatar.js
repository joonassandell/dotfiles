import { div, svg, image } from 'gpui-kit';
import { h_flex } from 'gpui-base';
import { shared, theme } from 'herdr';
import { MARK, INHERITED_TEXT, MOD, firstLetter } from './model.js';

// Herdr's own avatar is 18px, and the gap to the name is 9px (set by the row). Every kind here uses
// the same box and the same corner radius, so only what is inside changes.
export const SIZE = 18;
const RADIUS = 5;
const LETTER = 10.5; // one letter, as in Herdr
const LETTERS = 9; // two letters, a bit smaller to fit

// A color by name: Herdr's avatar colors, a theme color, or #rrggbb.
export function resolve(color) {
  if (!color) return null;
  return color.startsWith('#') ? color : MARK[color] ?? theme()[color] ?? null;
}

// The space's own color, as Herdr gives it.
export function inheritedFill(spaceId) {
  return resolve((shared('space.colors') ?? {})[spaceId] ?? 'ansi6');
}

const box = (size) => h_flex().size(size).flex_none().rounded(size * RADIUS / SIZE).overflow_hidden().items_center().justify_center();

// The avatar Herdr draws when nothing is chosen.
export function defaultAvatar(name, spaceId, size = SIZE) {
  return box(size).bg(inheritedFill(spaceId)).text_size(size * LETTER / SIZE).font_bold().text_color(INHERITED_TEXT).child(firstLetter(name));
}

// A chosen avatar. `path` is where the image to draw is (images only; null until it is ready).
export function avatar(spec, name, spaceId, path, size = SIZE) {
  if (spec.kind === 'image') {
    if (!path) return defaultAvatar(name, spaceId, size);
    return box(size).child(image(path).size(size).rounded(size * RADIUS / SIZE));
  }
  const background = resolve(spec.background) ?? inheritedFill(spaceId);
  const foreground = resolve(spec.foreground) ?? INHERITED_TEXT;
  if (spec.kind === 'icon') {
    return box(size).bg(background).child(svg(`mods/${MOD}/icons/${spec.icon}.svg`).size(size * 0.68).text_color(foreground));
  }
  const letters = [...spec.text].length;
  return box(size).bg(background).text_size(size * (letters > 1 ? LETTERS : LETTER) / SIZE).font_bold().text_color(foreground)
    .child(div().w_full().text_center().child(spec.text));
}
