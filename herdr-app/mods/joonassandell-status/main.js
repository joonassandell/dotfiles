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
//
// The branch is a link: a click opens its pull request on GitHub (through `gh`), or the
// branch's page on the remote host when there is none; Cmd+click copies the branch name.
import { View, div, svg } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, focused, theme, exec, home, checking } from "herdr";

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

// The web address of a git remote: git@host:owner/repo.git, ssh://git@host/owner/repo
// and https://host/owner/repo.git all become https://host/owner/repo.
function webUrl(remote) {
  const m = remote.trim().match(/^(?:[a-z+]+:\/\/)?(?:[^@/]+@)?([^:/]+)[:/](.+?)(?:\.git)?\/?$/);
  return m ? `https://${m[1]}/${m[2]}` : null;
}

// Runs a command line tool the app may not find on its own PATH.
async function tool(name, args, cwd) {
  for (const cmd of [name, `/opt/homebrew/bin/${name}`, `/usr/local/bin/${name}`]) {
    try {
      const r = await exec(cmd, args, { cwd, timeout: 10_000 });
      if (r.code !== 127) return r;
    } catch {}
  }
  return null;
}

// Opens the branch's pull request, else the branch's page on the remote host.
async function openBranch(dir, branch) {
  const remote = await tool("git", ["-C", dir, "remote", "get-url", "origin"]);
  const base = remote?.code === 0 ? webUrl(remote.stdout) : null;
  if (!base) return;
  let url = null;
  if (base.startsWith("https://github.com/")) {
    const pr = await tool("gh", ["pr", "view", branch, "--json", "url", "--jq", ".url"], dir);
    if (pr?.code === 0 && pr.stdout.trim().startsWith("https://")) url = pr.stdout.trim();
  }
  const tree = base.includes("gitlab") ? "/-/tree/" : "/tree/";
  await exec("open", [url ?? `${base}${tree}${branch.split("/").map(encodeURIComponent).join("/")}`]);
}

// A ring that fills clockwise from the top, drawn exactly like the agents list's spinner:
// rings/<percent>.svg are copies of spinner.svg (track at 24% opacity, round ends) with the
// arc set to that percent, tinted with `color`.
function ring(fraction, color, size = 12) {
  const percent = Math.max(0, Math.min(100, Math.round(fraction * 100)));
  return svg(`mods/joonassandell-status/rings/${percent}.svg`).size(size).flex_none().text_color(color);
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
          .child(ring(left / 100, color(left)))
          .child(div().text_color(stale ? t.dim : t.muted).child(`${label} ${left}%`))
          .when(q.resets[key] > Date.now(), el => el.child(div().text_color(t.dim).child(`↻ ${until(q.resets[key])}`)));
      }));
  }

  render() {
    const t = theme();
    const space = spaces().find(s => s.active);
    const label = (icon, text) => h_flex().gap(6).items_center().child(svg(`mods/workspace-chrome/${icon}.svg`).size(13)).child(text);
    const branch = (name) => label("branch", this.copied ? "Copied" : name).id("status-branch").cursor_pointer()
      .hover(s => s.text_color(t.foreground))
      .on_click((e, cx) => {
        if (e.modifiers?.platform) {
          cx.write_to_clipboard(name);
          this.copied = true;
          cx.notify();
          cx.spawn(async (cx) => { await cx.sleep(1200); this.copied = false; cx.notify(); });
          return;
        }
        const dir = focused()?.cwd || space?.folder;
        if (dir) cx.spawn(async () => { await openBranch(dir, name); });
      });
    const quota = this.quotaView(t);
    return h_flex().size_full().px(14).gap(16).items_center().bg(t.chrome).border_t(1).border_color(t.border).text_size(11.8).text_color(t.muted)
      .when(Boolean(space?.machine), el => el.child(label("server", space.machine)))
      .when(Boolean(space?.branch), el => el.child(branch(space.branch)))
      .child(div().flex_1())
      .when(Boolean(quota), el => el.child(quota));
  }
}
