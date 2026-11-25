import { div } from 'gpui-kit';
import { props, nextCommand, focused, openOverlay, theme } from 'herdr';
import Spaces from './spaces.js';
import Menu from './menu.js';
import Picker from './picker.js';
import { MOD } from './model.js';
import { footer } from './footer.js';

export default class JoonasSandellSpaces extends Spaces {
  init(_props, cx) {
    const p = props() ?? {};
    // An empty sidebar strip under the macOS window buttons, in place of the hidden brand row.
    if (p.mode === 'spacer') { this.spacer = true; return; }
    // The sidebar footer with Settings only (see footer.js).
    if (p.mode === 'footer') { this.footer = true; return; }
    if (p.mode === 'picker' || p.mode === 'menu') {
      this.overlayContent = cx.new(p.mode === 'picker' ? Picker : Menu, p);
      return;
    }
    // Herdr invalidates the mod root when shared state changes. Keep the sidebar
    // on that root; a retained child would otherwise keep its cached description.
    super.init(_props, cx);
    cx.spawn(async cx => {
      for (;;) {
        const command = await nextCommand();
        if (command === 'avatar') openOverlay({ mod: MOD, kind: 'dialog', width: 460, props: { mode: 'picker', space: focused()?.space } });
      }
    });
  }
  render() {
    if (this.spacer) return div().size_full().bg(theme().chrome);
    if (this.footer) return footer();
    return this.overlayContent ?? super.render();
  }
}
