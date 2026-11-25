// The "Change avatar" dialog: Default, Monogram, Icon (Lucide) or Image.
import { View, div, svg } from 'gpui-kit';
import { h_flex, v_flex, InputState, Input, Button } from 'gpui-base';
import { props, spaces, shared, closeOverlay, theme, exec } from 'herdr';
import { MOD, HUES, WHITE, DARK, INHERITED_TEXT, firstLetter, cleanLetters, validLetters, filterIcons, problem, cleanMatch, baseName, extensionOf, IMAGE_EXTENSIONS } from './model.js';
import { ICONS } from './catalogue.js';
import { avatar, defaultAvatar, resolve } from './avatar.js';
import { allAvatars, nameKey, saveAvatar, assetPath, materialize, specFor } from './store.js';
import { button, group, checkbox, ColorPicker } from './controls.js';

const MODES = [['default', 'Default'], ['monogram', 'Monogram'], ['icon', 'Icon'], ['image', 'Image']];
const SWATCHES = [...HUES, WHITE, DARK];
const COLUMNS = 9;
const PAGE = COLUMNS * 6;

export default class Picker extends View {
  init(_props, cx) {
    this.id = props()?.space;
    this.space = spaces().find(s => s.id === this.id);
    const name = this.space?.name ?? '';
    // What the space shows now: its own entry, else one whose word matches its name.
    const saved = allAvatars()[nameKey(name)] ?? specFor(allAvatars(), name) ?? {};
    this.draft = {
      kind: ['monogram', 'icon', 'image'].includes(saved.kind) ? saved.kind : 'default',
      text: saved.text ?? firstLetter(name),
      icon: saved.icon ?? 'folder-code',
      override: Boolean(saved.background || saved.foreground),
      background: saved.background ?? null,
      foreground: saved.foreground ?? null,
      source: saved.source ?? '',
      mode: saved.mode === 'copy' ? 'copy' : 'reference', // the file path is the default
      match: saved.match ?? '',
    };
    this.handle = cx.focus_handle();
    this.handle.focus();
    this.error = ''; this.busy = false; this.query = ''; this.page = 0; this.browse = 'popular';
    this.drawn = saved.kind === 'image' ? assetPath(saved) : null; // the image asset the preview may draw
    this.search = this.input('', value => { this.query = value; this.page = 0; }, 'Search icons…');
    this.letters = this.input(this.draft.text, value => { this.draft.text = value; });
    this.matchInput = this.input(this.draft.match, value => { this.draft.match = value; }, 'Word');
    this.hex = {}; this.pickers = {};
    for (const key of ['background', 'foreground']) {
      this.hex[key] = this.input(resolve(this.draft[key]) ?? '', value => {
        const v = value.trim();
        this.badHex = this.badHex ?? {};
        this.badHex[key] = Boolean(v) && !/^#[a-f0-9]{6}$/i.test(v);
        if (/^#[a-f0-9]{6}$/i.test(v) && v.toLowerCase() !== (resolve(this.draft[key]) ?? '').toLowerCase()) this.draft[key] = v;
      }, '#rrggbb');
      this.pickers[key] = new ColorPicker(key, () => resolve(this.draft[key]) ?? '#888888', value => { this.draft[key] = value; this.hex[key].set_value(value); });
    }
  }

  input(value, change, placeholder = '') {
    const input = InputState.new({ value, placeholder });
    input.on('change', (_e, cx) => { change(input.value()); this.error = ''; cx.notify(); });
    return input;
  }

  // ---- the draft as a saved avatar ----

  spec() {
    const d = this.draft;
    const colors = d.override ? { background: d.background, foreground: d.foreground } : {};
    const word = cleanMatch(d.match);
    const match = word ? { match: word } : {};
    if (d.kind === 'monogram') return { kind: 'monogram', text: cleanLetters(d.text), ...colors, ...match };
    if (d.kind === 'icon') return { kind: 'icon', icon: d.icon, ...colors, ...match };
    if (d.kind === 'image') return { kind: 'image', source: d.source, mode: d.mode, ...match };
    return null;
  }

  preview(size) {
    const spec = this.spec();
    const name = this.space?.name ?? '';
    if (!spec || problem(spec)) return defaultAvatar(name, this.id, size);
    return avatar(spec, name, this.id, spec.kind === 'image' && this.drawn === assetPath(spec) ? this.drawn : null, size);
  }

  // ---- image ----

  useImage(source, cx) {
    const d = this.draft;
    if (!source || this.busy) return;
    this.error = '';
    if (!IMAGE_EXTENSIONS.includes(extensionOf(source))) { this.error = `Use a ${IMAGE_EXTENSIONS.join(', ')} file.`; cx.notify(); return; }
    d.kind = 'image'; d.source = source;
    this.make(cx);
  }

  // Brings the chosen image into the app folder, as a copy or a link.
  make(cx) {
    const spec = this.spec();
    this.busy = true;
    cx.spawn(async cx => {
      try { this.drawn = await materialize(spec); }
      catch (error) { this.drawn = null; this.error = String(error.message ?? error); }
      finally { this.busy = false; cx.notify(); }
    });
  }

  choose(cx) {
    if (this.busy) return;
    this.busy = true; this.error = ''; cx.notify();
    cx.spawn(async cx => {
      let path = '';
      try {
        // Finder gives the standard macOS file dialog, and being active it shows in front.
        const script = 'tell application "Finder"\nactivate\ntry\nreturn POSIX path of (choose file of type {"public.image"} with prompt "Choose an image for the space")\non error\nreturn ""\nend try\nend tell';
        path = (await exec('osascript', ['-e', script], { timeout: 600000 })).stdout.trim();
      } catch (error) { this.error = String(error.message ?? error); }
      this.busy = false; cx.notify();
      if (path) this.useImage(path, cx);
    });
  }

  // ---- saving ----

  save(cx) {
    const spec = this.spec();
    const error = problem(spec) || (!this.space ? 'This space is no longer available.' : '');
    if (error || this.busy) { this.error = error; cx.notify(); return; }
    this.busy = true;
    cx.spawn(async cx => {
      try {
        if (spec?.kind === 'image') await materialize(spec);
        await saveAvatar(this.space.name, spec);
        closeOverlay(props()?.overlay);
      } catch (error) { this.error = String(error.message ?? error); }
      finally { this.busy = false; cx.notify(); }
    });
  }

  key(e, cx) {
    if (e.key === 'escape') { closeOverlay(props()?.overlay); cx.stop_propagation(); }
  }

  // ---- pieces ----

  label(text, color) { return div().h(16).flex_none().text_size(11).text_color(color ?? theme().muted).child(text); }

  field(input, id, hint = '') {
    const t = theme();
    return Input.new(input).id(id).accessibility_label(hint || id).h(33).px(9).rounded(7).border_1().border_color(t.input)
      .bg(t.background).text_color(t.foreground).text_size(12);
  }

  swatches(key) {
    const d = this.draft, t = theme();
    return h_flex().gap(5).children(SWATCHES.map(color => Button.new(`jss-${key}-${color}`).tab_index(0)
      .accessibility_label(`${key === 'background' ? 'Background' : 'Text'} ${color}`).size(24).rounded(6).bg(resolve(color))
      .border(d[key] === color ? 2 : 1).border_color(d[key] === color ? t.foreground : t.border).cursor_pointer()
      .on_click((_e, cx) => { d[key] = color; this.hex[key].set_value(resolve(color)); cx.notify(); })));
  }

  colorRow(key, title) {
    const t = theme();
    return v_flex().gap(7)
      .child(this.label(title))
      .child(this.swatches(key))
      .child(h_flex().gap(7).items_center()
        .child(this.pickers[key].render())
        .child(div().flex_1().child(this.field(this.hex[key], `jss-${key}-hex`, '#rrggbb'))))
      .when(this.badHex?.[key], el => el.child(this.label('Use a color like #5b8def.', t.blocked)));
  }

  colors() {
    const d = this.draft;
    return v_flex().gap(12).flex_none()
      .child(div().h(18).flex_none().child(checkbox('jss-override', 'Override colors', d.override, checked => {
        d.override = checked;
        if (checked) {
          d.background = (shared('space.colors') ?? {})[this.id] ?? 'ansi6';
          d.foreground = INHERITED_TEXT;
          this.hex.background.set_value(resolve(d.background) ?? '');
          this.hex.foreground.set_value(resolve(d.foreground) ?? '');
        } else {
          d.background = null; d.foreground = null;
          this.badHex = {};
        }
      })))
      .when(d.override, el => el.child(this.colorRow('background', 'Background')).child(this.colorRow('foreground', 'Text')));
  }

  monogram() {
    const t = theme(), d = this.draft;
    const invalid = !validLetters(d.text);
    return v_flex().gap(8).flex_none()
      .child(this.label('Letters'))
      .child(this.field(this.letters, 'jss-letters', 'AB').when(invalid, el => el.border_color(t.blocked)))
      .child(this.label('Use max 2 letters or numbers', invalid ? t.blocked : undefined));
  }

  tile(name) {
    const t = theme(), on = this.draft.icon === name;
    return Button.new(`jss-icon-${name}`).tab_index(0).accessibility_label(name + (on ? ', selected' : '')).tooltip(name)
      .size(38).rounded(7).flex().items_center().justify_center().border_1().border_color(on ? t.accent : t.border)
      .bg(on ? t.selected : t.popover).cursor_pointer().hover(s => s.bg(t.hover))
      .on_click((_e, cx) => { this.draft.icon = name; cx.notify(); })
      .child(svg(`mods/${MOD}/icons/${name}.svg`).size(18).text_color(t.foreground));
  }

  iconLayout() {
    const matches = this.query.trim() ? filterIcons(ICONS, this.query) : this.browse === 'all' ? ICONS : filterIcons(ICONS, '');
    const pages = Math.max(1, Math.ceil(matches.length / PAGE));
    this.page = Math.min(this.page, pages - 1);
    const items = matches.slice(this.page * PAGE, (this.page + 1) * PAGE);
    return { matches, pages, items, count: items.length, rows: Math.ceil(items.length / COLUMNS) };
  }

  icons() {
    const t = theme();
    const { pages: count, items } = this.iconLayout();
    const rows = [];
    for (let i = 0; i < items.length; i += COLUMNS) rows.push(h_flex().gap(5).children(items.slice(i, i + COLUMNS).map(name => this.tile(name))));
    return v_flex().gap(8).flex_none()
      .child(h_flex().gap(8).items_center()
        .child(group('jss-browse', [['popular', 'Popular'], ['all', `All (${ICONS.length})`]], this.browse, browse => { this.browse = browse; this.page = 0; this.query = ''; this.search.set_value(''); })))
      .child(this.field(this.search, 'jss-search', `Search ${ICONS.length} Lucide icons…`))
      .child(v_flex().gap(5).children(rows))
      .when(!items.length, el => el.child(this.label('No icons found.')))
      .when(count > 1, el => el.child(h_flex().gap(8).items_center().justify_end()
        .child(button('jss-prev', 'Previous', () => { this.page--; }, false, this.page === 0))
        .child(this.label(`${this.page + 1} / ${count}`))
        .child(button('jss-next', 'Next', () => { this.page++; }, false, this.page >= count - 1))));
  }

  image() {
    const d = this.draft, t = theme();
    return h_flex().gap(10).items_center().flex_none()
      .child(button('jss-choose', 'Choose or drop an image', cx => this.choose(cx), false, this.busy))
      .when(Boolean(d.source), el => el.child(div().id('jss-source').flex_1().min_w(0).truncate().tooltip(d.source).text_size(12).text_color(t.muted).child(baseName(d.source))));
  }

  reference() {
    const d = this.draft;
    return div().w_full().h(38).flex_none().child(checkbox('jss-reference', 'Use the file path instead of copying. With this setting, moving or deleting the file removes the avatar.', d.mode === 'reference', (checked, cx) => {
      d.mode = checked ? 'reference' : 'copy';
      if (d.source) this.make(cx);
    }));
  }

  content() {
    const d = this.draft;
    if (d.kind === 'monogram') return this.monogram();
    if (d.kind === 'icon') return this.icons();
    if (d.kind === 'image') return this.image();
    return v_flex().gap(6).flex_none()
      .child(this.label('The original Herdr avatar. Saving this removes the custom avatar.'));
  }

  // Which other spaces would show this avatar: their names contain the word, and they have no entry of their own.
  alsoUsedBy() {
    const word = cleanMatch(this.draft.match);
    if (!word) return null;
    const own = allAvatars();
    return spaces().filter(s => s.id !== this.id && nameKey(s.name).includes(word) && !own[nameKey(s.name)]).map(s => s.name);
  }

  matchSection() {
    const others = this.alsoUsedBy();
    const hint = others?.length ? `Also used by: ${others.join(', ')}` : others ? 'No other space has this word yet.' : '';
    return v_flex().gap(7).flex_none()
      .child(this.label(`Use this ${{ monogram: 'monogram', image: 'image' }[this.draft.kind] ?? 'icon'} if the space name contains this word`))
      .child(this.field(this.matchInput, 'jss-match', 'Word'))
      .when(Boolean(hint), el => el.child(div().h(16).flex_none().truncate().text_size(11).text_color(theme().muted).child(hint)));
  }

  // The dialog is as tall as its content, so there is no empty space above the footer.
  // Every part has a fixed height (labels 16, fields 33, buttons 30, tiles 38), which adds up here.
  colorsHeight() {
    const d = this.draft;
    if (!d.override) return 18;
    const row = key => 16 + 7 + 24 + 7 + 33 + (this.badHex?.[key] ? 7 + 16 : 0);
    return 18 + 12 + row('background') + 12 + row('foreground');
  }

  bodyHeight() {
    const d = this.draft, divided = 14 + 1 + 14;
    const match = divided + 16 + 7 + 33 + (cleanMatch(d.match) ? 7 + 16 : 0);
    if (d.kind === 'monogram') return 16 + 8 + 33 + 8 + 16 + divided + this.colorsHeight() + match;
    if (d.kind === 'image') return 30 + divided + 38 + match;
    if (d.kind === 'icon') {
      const { count, rows, pages } = this.iconLayout();
      return 29 + 8 + 33 + 8 + (count ? rows * 38 + (rows - 1) * 5 : 16) + (pages > 1 ? 8 + 30 : 0) + divided + this.colorsHeight() + match;
    }
    return 16;
  }

  render(cx) {
    const t = theme(), d = this.draft;
    const invalid = problem(this.spec()) || (!this.space ? 'This space is no longer available.' : '');
    const shown = this.error || (d.kind === 'default' ? '' : invalid && (d.kind !== 'image' || d.source) ? invalid : '');
    const divider = () => div().h(1).flex_none().bg(t.border);
    // 20 padding twice, header 26, tabs 29, footer 30, and a 14 gap between each of the five rows.
    const wanted = 40 + 26 + 29 + 30 + 14 * 4 + this.bodyHeight() + (shown ? 14 + 16 : 0);
    return v_flex().id('joonassandell-spaces-picker').track_focus(this.handle).on_key_down((e, cx) => this.key(e, cx))
      .w_full().h(Math.min(wanted, Math.max(240, window.viewport_size().height - 32))).min_h(0).p(20).gap(14).bg(t.popover).text_color(t.foreground).text_size(12)
      .on_drop((event, cx) => { if (event.paths?.length) this.useImage(event.paths[0], cx); })
      .child(h_flex().h(26).flex_none().items_center().justify_between()
        .child(div().text_size(17).font_semibold().child('Change avatar'))
        .child(h_flex().gap(9).items_center().min_w(0).child(this.preview(18))
          .child(div().max_w(180).truncate().text_color(t.foreground).child(this.space?.name ?? 'Space is gone'))))
      .child(group('jss-mode', MODES, d.kind, mode => { d.kind = mode; this.error = ''; this.page = 0; }))
      .child(v_flex().id('jss-body').flex_1().min_h(0).gap(14).overflow_y_scroll()
        .child(this.content())
        .when(d.kind === 'image', el => el.child(divider()).child(this.reference()))
        .when(d.kind === 'monogram' || d.kind === 'icon', el => el.child(divider()).child(this.colors()))
        .when(d.kind !== 'default', el => el.child(divider()).child(this.matchSection())))
      .when(Boolean(shown), el => el.child(div().id('jss-error').h(16).flex_none().text_size(11).text_color(t.blocked).child(shown)))
      .child(h_flex().h(30).flex_none().gap(8).justify_end()
        .child(button('jss-cancel', 'Cancel', () => closeOverlay(props()?.overlay)))
        .child(button('jss-save', 'Save', cx => this.save(cx), true, Boolean(d.kind !== 'default' && invalid) || this.busy || !this.space)));
  }
}
