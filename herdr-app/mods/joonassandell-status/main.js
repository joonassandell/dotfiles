// The bottom status bar: Herdr's stock `workspace-status` (0.1.18) without the
// command palette hint, the "This computer" label (a remote machine's name
// still shows) and the agent count (the sidebar's agents list shows who needs
// you), plus Claude's quota on the right.
//
// The quota comes from the Hermes quota plugin, which writes Anthropic's usage
// to ~/.hermes/quota_anthropic_shared.json. This mod only reads that file, so
// the numbers are as fresh as the plugin's last check; when the newest check is
// older than STALE_MS the quota is drawn dimmed, and older than GONE_MS (the
// plugin is off or gone) it is hidden.
import { View, div, svg, PathBuilder } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, theme, exec, home, checking } from "herdr";

const POLL_MS = 60_000;
const STALE_MS = 30 * 60_000;
const GONE_MS = 24 * 60 * 60_000;
const WINDOWS = [["five_hour", "Current"], ["seven_day", "Week"]];

// Reads the newest entry in the plugin's file:
// { at (ms), left: { five_hour: %, seven_day: % }, resets: { five_hour: ms, seven_day: ms } }.
async function readQuota() {
  try {
    const r = await exec("cat", [`${home()}/.hermes/quota_anthropic_shared.json`]);
    if (r.code !== 0) return null;
    const entries = Object.values(JSON.parse(r.stdout) ?? {}).filter((e) => e && e.payload && typeof e.at === "number");
    const latest = entries.sort((a, b) => b.at - a.at)[0];
    if (!latest) return null;
    const left = {}, resets = {};
    for (const [key] of WINDOWS) {
      const used = latest.payload[key]?.utilization;
      if (typeof used === "number") left[key] = Math.max(0, Math.min(100, Math.round(100 - used)));
      const reset = Date.parse(latest.payload[key]?.resets_at ?? "");
      if (!Number.isNaN(reset)) resets[key] = reset;
    }
    return { at: latest.at * 1000, left, resets };
  } catch {
    return null;
  }
}

// Time until a reset, like the Hermes quota plugin: "57m", "3h 12m", "5d 3h".
function until(ms) {
  const m = Math.max(1, Math.ceil((ms - Date.now()) / 60_000));
  if (m < 60) return `${m}m`;
  const h = Math.floor(m / 60);
  if (h < 24) return `${h}h ${m % 60}m`;
  return `${Math.floor(h / 24)}d ${h % 24}h`;
}

// A ring that fills clockwise from the top: the track in `track`, `fraction` of it in `color`.
function ring(fraction, color, track, size = 12, width = 2) {
  const c = size / 2, r = c - width / 2;
  const point = (f) => [c + r * Math.sin(f * 2 * Math.PI), c - r * Math.cos(f * 2 * Math.PI)];
  const circle = PathBuilder.stroke(width).move_to(c, c - r).arc_to(r, r, 0, false, true, c, c + r).arc_to(r, r, 0, false, true, c, c - r).build();
  const el = div().relative().size(size).flex_none().child(window.paint_path(circle, track).absolute().left(0).top(0).size(size));
  if (fraction <= 0) return el;
  const arc = fraction >= 0.999 ? circle : (() => {
    const [x, y] = point(fraction);
    return PathBuilder.stroke(width).move_to(c, c - r).arc_to(r, r, 0, fraction > 0.5, true, x, y).build();
  })();
  return el.child(window.paint_path(arc, color).absolute().left(0).top(0).size(size));
}

export default class JoonassandellStatus extends View {
  init(_props, cx) {
    this.quota = null;
    if (checking()) return;
    const refresh = async (cx) => {
      const next = await readQuota();
      // Redraw every poll, even with the same numbers, so the reset countdown moves.
      this.quota = next;
      cx.notify();
    };
    cx.spawn(refresh);
    cx.timer.every(POLL_MS, (cx) => { refresh(cx); });
  }

  quotaView(t) {
    const q = this.quota;
    if (!q || !Object.keys(q.left).length) return null;
    const age = Date.now() - q.at;
    if (age > GONE_MS) return null;
    const stale = age > STALE_MS;
    const color = (left) => (stale ? t.dim : left <= 10 ? t.ansi1 : left <= 30 ? t.ansi3 : t.ansi2);
    return h_flex().gap(14).items_center()
      .children(WINDOWS.filter(([key]) => key in q.left).map(([key, label]) => {
        const left = q.left[key];
        return h_flex().gap(6).items_center()
          .child(ring(left / 100, color(left), t.border))
          .child(div().text_color(stale ? t.dim : t.muted).child(`${label} ${left}%`))
          .when(q.resets[key] > Date.now(), el => el.child(div().text_color(t.dim).child(`↻ ${until(q.resets[key])}`)));
      }));
  }

  render() {
    const t = theme();
    const space = spaces().find(s => s.active);
    const label = (icon, text) => h_flex().gap(6).items_center().child(svg(`mods/workspace-chrome/${icon}.svg`).size(13)).child(text);
    const quota = this.quotaView(t);
    return h_flex().size_full().px(14).gap(16).items_center().bg(t.chrome).border_t(1).border_color(t.border).text_size(11.8).text_color(t.muted)
      .when(Boolean(space?.machine), el => el.child(label("server", space.machine)))
      .when(Boolean(space?.branch), el => el.child(label("branch", space.branch)))
      .child(div().flex_1())
      .when(Boolean(quota), el => el.child(quota));
  }
}
