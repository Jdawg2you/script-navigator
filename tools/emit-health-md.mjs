#!/usr/bin/env node
/* Writes scripts/health-discovery.md from the live Health Discovery script in index.html.
   Run from the repo root:  node tools/emit-health-md.mjs   (--check: exit 1 if the .md is stale)

   Exists because the .md was hand-written once (8cd80e6) and then drifted for 13 commits while
   the cards in LIB.health kept changing; a script review was written against the stale copy.
   The cards are the script. This file is only a readable print of them - never edit it by hand.

   What it reads, all from index.html, by name:
     LIB.health     the cards (N), their numbers (ID), sections (S, P), stages and entry points
     PF_SPEC_HEALTH the profile fields - labels and options behind {{key}} chips and `pf` lines
     BLANKMAP       which profile field each ___(label) blank fills
     DEFAULT_BIO    what ___(your bio) says when the agent has not written their own
   The objects are cut out with a string- and comment-aware bracket matcher and evaluated on
   their own, so nothing else in the page has to run. */

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { execSync } from "node:child_process";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const SRC = join(ROOT, "index.html");
const OUT = join(ROOT, "scripts", "health-discovery.md");
const html = readFileSync(SRC, "utf8");

/* ---- cut a literal out of the page ------------------------------------------------------ */
function matchFrom(src, open) {
  const pairs = { "{": "}", "[": "]", "(": ")" }, stack = [];
  for (let i = open; i < src.length; i++) {
    const c = src[i], d = src[i + 1];
    if (c === '"' || c === "'" || c === "`") {
      for (i++; i < src.length && src[i] !== c; i++) if (src[i] === "\\") i++;
      continue;
    }
    if (c === "/" && d === "*") { i = src.indexOf("*/", i + 2) + 1; continue; }
    if (c === "/" && d === "/") { i = src.indexOf("\n", i); continue; }
    if (pairs[c]) stack.push(pairs[c]);
    else if (c === "}" || c === "]" || c === ")") {
      if (stack.pop() !== c) throw new Error("unbalanced " + c + " at " + i);
      if (!stack.length) return i + 1;
    }
  }
  throw new Error("no close for literal at " + open);
}
function literal(marker, re) {
  const at = re ? html.search(re) : html.indexOf(marker);
  if (at < 0) throw new Error("not found in index.html: " + (marker || re));
  const open = html.slice(at).search(/[\[{]/) + at;
  return new Function("return (" + html.slice(open, matchFrom(html, open)) + ")")();
}
const H = literal(null, /\bhealth:\{\s*first:"hs_start"/);
const SPEC = literal("PF_SPEC_HEALTH=[");
const BLANKMAP = literal("var BLANKMAP={");
const DEFAULT_BIO = new Function("return " + html.match(/var DEFAULT_BIO=("(?:[^"\\]|\\.)*")/)[1])();

const FIELD = {};
SPEC.forEach(f => { if (f.k) FIELD[f.k] = f; });

/* ---- HTML in a card line -> markdown ---------------------------------------------------- */
const ENT = { mdash: "—", ndash: "–", hellip: "…", middot: "·", ldquo: "“", rdquo: "”",
  lsquo: "‘", rsquo: "’", amp: "&", lt: "<", gt: ">", quot: '"', nbsp: " ", "#9733": "★" };
const ent = s => s.replace(/&(#?\w+);/g, (m, e) => ENT[e] ?? (e[0] === "#" ? String.fromCodePoint(+e.slice(1)) : m));
const strip = s => ent(s.replace(/<[^>]+>/g, "")).trim();
const label = k => (FIELD[k] ? strip(FIELD[k].l || k) : k);

function chip(k) {
  const f = FIELD[k];
  if (!f || !f.opt) return "";       // the page draws nothing for a token with no options
  const opts = f.opt.filter(o => o !== "").join(" · ");
  return "[" + label(k) + (f.multi ? " (pick any)" : "") + ": " + opts + "]";
}

/* returns {text, folds[]} - a <details> fold-out becomes its own nested list under the line */
function md(x) {
  const folds = [];
  x = String(x || "").replace(/<details[^>]*>\s*<summary>([\s\S]*?)<\/summary>([\s\S]*?)<\/details>/g, (m, sum, body) => {
    const items = [...body.matchAll(/<li>([\s\S]*?)<\/li>/g)].map(r => inline(r[1]));
    const ordered = /<ol>/.test(body);
    const foot = (body.match(/<small>([\s\S]*?)<\/small>/) || [])[1];
    folds.push({ title: strip(sum), items, ordered, foot: foot ? inline(foot) : "" });
    return "";
  });
  return { text: inline(x), folds };
}
function inline(x) {
  return ent(x
    .replace(/<span class="optpill">([\s\S]*?)<\/span>/g, (m, t) => "`" + strip(t) + "`")
    .replace(/<span class="chiplbl">([\s\S]*?)<\/span>/g, (m, t) => strip(t) + ":")
    .replace(/<br\s*\/?>/g, " / ")
    .replace(/<\/?(b|strong)>/g, "**")
    .replace(/<\/?(i|em)>/g, "*")
    .replace(/<[^>]+>/g, "")
    .replace(/\{\{c:([^}]+)\}\}/g, (m, c) => "[☐ " + c + "]")
    .replace(/\{\{([a-z0-9_]+)\}\}/gi, (m, k) => chip(k))
    .replace(/_{3,}\s*\(([^)]+)\)/g, (m, lab) => "___(" + lab + ")")
  ).replace(/\*\*\s*\*\*/g, "").replace(/\s+/g, " ").trim();
}

/* ---- conditions --------------------------------------------------------------------- */
function want(w) {
  const one = v => (v === "" ? "not answered" : "“" + String(v).replace(/^~/, "") + "”");
  const vs = Array.isArray(w) ? w : [w];
  return (vs.some(v => String(v).startsWith("~")) ? "includes " : "is ") + vs.map(one).join(" or ");
}
const KEYNAME = { did_discovery: "Full discovery done (set at 7.1)" };
const pair = p => (KEYNAME[p[0]] || label(p[0])) + " (`" + p[0] + "`) " + want(p[1]);
function when(w, dflt) {
  if (!w) return "";
  const s = Array.isArray(w[0]) ? w.map(pair).join(", **or** ") : pair(w);
  return "_only when " + s + (dflt ? "; also shown before it is answered" : "") + "_";
}
const allOf = a => "_only when " + a.map(pair).join(", **and** ") + "_";

/* ---- card numbers ------------------------------------------------------------------- */
const num = id => H.ID[id];
const sortKey = n => n.split(".").map(p => { const m = p.match(/^(\d+)([a-z]*)$/); return [+m[1], m[2]]; });
function cmp(a, b) {
  const A = sortKey(a), B = sortKey(b);
  for (let i = 0; i < Math.max(A.length, B.length); i++) {
    if (!A[i]) return -1; if (!B[i]) return 1;
    if (A[i][0] !== B[i][0]) return A[i][0] - B[i][0];
    if (A[i][1] !== B[i][1]) return A[i][1] < B[i][1] ? -1 : 1;
  }
  return 0;
}
const ref = id => (num(id) ? num(id) + " " : "") + (H.N[id] ? H.N[id].t.replace(/“|”/g, '"') : "MISSING CARD") + " (`" + id + "`)";

/* ---- one line ----------------------------------------------------------------------- */
const TAG = { say: "SAY", ask: "ASK", do: "DO", dobig: "DO (big)", tip: "TIP", train: "TRAIN",
  warn: "WARN ★", note: "NOTE", paper: "PAPER", askif: "ASK" };
const WIDGET = {
  meds: L => "Medication entry" + (L.who === "sp" ? " — spouse's list" : ""),
  cfollow: L => "Follow-up questions for the conditions the medications point to" + (L.who === "sp" ? " — spouse" : ""),
  conds: L => "Condition checklist" + (L.who === "sp" ? " — spouse" : ""),
  deps: () => "Children: name, date of birth, gender for each",
  docs: () => "Doctors to keep: name, must-keep, checked with their plan",
  fhgrid: L => L.rows === "preg"
    ? "Yes/no grid: " + ["pregnant", "mat_needs"].map(label).join(" · ") + " (applicant and spouse)"
    : "Yes/no grid: " + ["fh_cancer", "fh_heart", "fh_stroke", "mh_needs"].map(label).join(" · ") + " (applicant and spouse)",
  appt: () => "Appointment picker: " + ["appt_date", "appt_time"].map(label).join(" · "),
  handoff: () => "Buttons: Save the profile · Print the profile · Push client to MyPopPro",
  nextsteps: () => "What happens next: ✓ Discovery call → Intake (check what the call filled in) → Quote → Present → Enroll → Benefits Review. Button: Review the Intake →",
};
function line(L) {
  let cond = when(L.when, L.dflt);
  if (L.unless) cond = (cond ? cond.replace(/_$/, '') + '; ' : '_') + 'not when ' + pair(L.unless) + '_';   /* e.g. skip the protected-position ask for a current employer's plan */
  let head, body = "", folds = [];
  if (L.t === "pf") {
    head = "**COLLECT**";
    body = (L.ks || []).map(k => label(k) + " (`" + k + "`)" + (FIELD[k] && FIELD[k].opt ? ":" + (FIELD[k].multi ? " (pick any)" : "") + " " + FIELD[k].opt.filter(Boolean).join(" · ") : "")).join(" · ");
  } else if (WIDGET[L.t]) {
    head = "**ON SCREEN**";
    body = WIDGET[L.t](L);
  } else {
    head = "**" + (TAG[L.t] || L.t.toUpperCase()) + "**";
    /* this file is also the printable script, so the bio prints as the words the agent says */
    ({ text: body, folds } = md(String(L.x || "").replace(/_{3,}\s*\(your bio\)/g, DEFAULT_BIO.replace(/\$/g, "$$$$"))));
    if (/_{3,}\s*\(your bio\)/.test(L.x || "")) body += " _(the default bio — the agent's own bio from Set up replaces this)_";
  }
  let out = "- " + head + (cond ? " " + cond : "") + " — " + body;
  folds.forEach(f => {
    out += "\n  - Fold-out ▸ **" + f.title + "**";
    f.items.forEach((it, i) => { out += "\n    " + (f.ordered ? (i + 1) + "." : "-") + " " + it; });
    if (f.foot) out += "\n    \n    _" + f.foot + "_";
  });
  return out;
}

/* ---- the document ------------------------------------------------------------------- */
const ids = Object.keys(H.N);
const numbered = ids.filter(num).sort((a, b) => cmp(num(a), num(b)));
const unnumbered = ids.filter(id => !num(id));
const ghost = Object.keys(H.ID).filter(id => !H.N[id]);

let rev = "";
try {
  rev = execSync("git log -1 --format='%h %cs' -- index.html", { cwd: ROOT }).toString().trim();
  const branch = execSync("git rev-parse --abbrev-ref HEAD", { cwd: ROOT }).toString().trim();
  const dirty = execSync("git status --porcelain -- index.html", { cwd: ROOT }).toString().trim();
  rev = "`" + branch + "` @ " + rev + (dirty ? " + uncommitted changes" : "");
} catch { rev = "(not a git checkout)"; }

const o = [];
o.push("# Health Discovery — the live script",
  "",
  "**Generated — do not edit by hand.** Printed from `LIB.health` in `index.html` (" + rev + ") by",
  "`node tools/emit-health-md.mjs`. The cards in `index.html` are the script; change them there and regenerate.",
  "",
  "Every line of every card, in card-number order. Tags:",
  "",
  "- **SAY** / **ASK** — spoken to the client. **DO** / **DO (big)** — an instruction to the agent, on screen.",
  "- **TIP** / **NOTE** / **WARN ★** — boxed guidance on screen. **TRAIN** — training copy only; it is *not* drawn on the call screen.",
  "- **COLLECT** — profile fields filled in on the card (shown when the profile is on). **ON SCREEN** — a capture widget.",
  "- `___(label)` — a blank the agent fills or the profile fills in (see *Blanks* at the end). `[Field: A · B]` — answer chips.",
  "- _only when …_ — the line or button appears only when that answer holds.",
  "",
  "## Stages",
  "");
H.STAGES.forEach(st => o.push("- **" + st.n + " · " + st.lbl + "** — sections " + st.secs.map(s => s + " " + H.S[s] + " (starts at " + num(H.ENTRY[s]) + ")").join(", ")));
o.push("", "The call opens at " + ref(H.first) + ".", "");

let sec = null;
const card = id => {
  const n = H.N[id];
  if (n.s !== sec) {
    sec = n.s;
    o.push("---", "", "## " + sec + " · " + (H.S[sec] || "") , "", "_" + (H.P[sec] || "") + "_", "");
  }
  o.push("### " + (num(id) || "?") + " · " + n.t.replace(/“|”/g, '"') + "  `" + id + "`", "");
  const meta = [];
  if (n.pf) meta.push("opens the profile at *" + strip((SPEC.find(f => f.id === n.pf) || {}).sec || n.pf) + "*");
  if (n.mark) meta.push("reaching it sets `" + n.mark + "`");
  if (n.unmark) meta.push("reaching it clears `" + n.unmark + "`");
  if (meta.length) o.push("_Card: " + meta.join("; ") + "._", "");
  (n.l || []).forEach((L, i) => { if (!L) throw new Error(id + " line " + i + " is an empty slot"); o.push(line(L)); });
  o.push("");
  if (n.b && n.b.length) {
    o.push("**" + (n.bh ? n.bh : "Buttons") + "**", "");
    n.b.forEach(b => o.push("- [" + b.k + "] → " + ref(b.to) +
      (b.c === "alert" ? " · _alert_" : "") +
      (b.when ? " · " + when(b.when) : "") + (b.allOf ? " · " + allOf(b.allOf) : "")));
    o.push("");
  }
};
numbered.forEach(card);
if (unnumbered.length) { sec = null; o.push("---", "", "## Cards with no number", ""); unnumbered.forEach(card); }

/* every ___(label) used, and what fills it */
const blanks = new Map();
ids.forEach(id => (H.N[id].l || []).forEach(L => {
  for (const m of String(L.x || "").matchAll(/_{3,}\s*\(([^)]+)\)/g))
    if (!blanks.has(m[1])) blanks.set(m[1], num(id) || id);
}));
o.push("---", "", "## Blanks", "", "Each `___(label)` in the cards, the card it first appears on, and the profile field it reads and writes.", "",
  "| Blank | First on | Fills from |", "|---|---|---|");
[...blanks].forEach(([lab, at]) => {
  const k = BLANKMAP[lab];
  const what = k === undefined ? "— (typed on the call, not saved)"
    : k === "" ? "— (typed on the call, not saved)"
    : k === "a_bio" ? "the agent's bio (Set up), else the default bio"
    : k.startsWith("a_") ? "agent Set up: `" + k + "`"
    : label(k) + " (`" + k + "`)";
  o.push("| ___(" + lab + ") | " + at + " | " + what + " |");
});
o.push("");
if (ghost.length) o.push("> **Numbered but no card:** " + ghost.map(g => "`" + g + "`").join(", "), "");

const text = o.join("\n").replace(/\n{3,}/g, "\n\n") + "\n";
if (process.argv.includes("--check")) {
  const cur = existsSync(OUT) ? readFileSync(OUT, "utf8") : "";
  const strip1 = s => s.replace(/^\*\*Generated.*\n.*\n/m, "");
  if (strip1(cur) !== strip1(text)) { console.log("STALE  scripts/health-discovery.md - run: node tools/emit-health-md.mjs"); process.exit(1); }
  console.log("ok    scripts/health-discovery.md matches LIB.health"); process.exit(0);
}
writeFileSync(OUT, text);
console.log("wrote scripts/health-discovery.md - " + numbered.length + " numbered cards" +
  (unnumbered.length ? ", " + unnumbered.length + " unnumbered: " + unnumbered.join(" ") : "") +
  (ghost.length ? ", ID entries with no card: " + ghost.join(" ") : ""));
