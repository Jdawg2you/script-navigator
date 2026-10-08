# Health discovery script — source, for incorporation into the navigator

Dropped here 2026-09-24 from the Health Insurance thread. **Nothing in `index.html` has been
touched.** These are source documents; incorporating them is the work.

## Files

| File | What it is |
|---|---|
| `health-discovery.md` | **The script.** 25 sections. Built from Kyle/ManhattanLife June 2025, HealthFirst July 2026, and three of Jesse's recorded calls (Livingston 9/15, Boo 9/21, Cosgriff 9/23). ★ marks what he isn't currently doing, with the cost of each omission. |
| `health-discovery-callsheet.html` | Same script, laid out to read live on a call. Sticky must-ask bar, FPL table inline. Standalone, no dependencies. |
| `health-discovery-v2-draft.md` | Earlier hybrid draft. Superseded by `health-discovery.md`; kept for the cut-list reasoning. |

## What incorporating it actually involves

The navigator stores scripts as **cards with branches inside `index.html`**, not as files. So:

1. **`SCRIPTS`** — add a fourth entry beside `veteran`, `iul`, `mortgage`:
   `{k:"health", ready:false, title:"…", desc:"…"}`. Keep `ready:false` until the cards resolve.
2. **`SCRIPT_CODE`** — currently `{veteran:"VET", mortgage:"MP", iul:"IUL"}`. Health needs a code.
3. **`LIB.health`** — the card content, matching the existing shape (`{first:"start", P:{…}, …}`).
   Every `to:` must name a real card or it's a dead button, and `tools/check.sh` will catch it.
4. **Profile** — `PF_SPEC` is the current client profile and `PROFILE_ON` is `false`. Jesse wants a
   **health-specific variant**, not the regular one. See the field list below.

## The POP Pro push

The navigator already hands off to the wizard over postMessage:

```js
{source:"optimum-suite", type:"client", v:1, client:wizClient()}
```

A POP Pro push should follow the same shape rather than inventing a second protocol. Worth
knowing before designing it: **POP Pro loads a saved quote from a file picker only** — there is no
URL or hash loader in `~/Documents/poppro/tool/index.html`. A live postMessage handoff therefore
needs a receiver added on the POP Pro side, which is that repo's change, not this one.

Canonical field names are in `~/optimum-crm/FIELDS.md`. Two traps: POP Pro's `client.date` means
**date of birth** and `client.page` means **age**.

## What the health profile needs that the regular one doesn't

From the cases run so far — each of these was missing at least once and cost real work:

- **ZIP, not state.** AZ and FL price by county; without it there is no marketplace comparison.
- **Income this year *and* next year.** Next year's figure decides subsidy eligibility, which
  decides the whole recommendation. Needs a read-back flag — spoken money transcribes badly.
- **Household size + the FPL cliff.** 2026: 1 person $62,600 · 2 $84,600 · 3 $106,600 ·
  4 $128,600 · 5 $150,600. A live "are they near the line?" check is the single highest-value
  thing on the call: one case was $1,200/month either side of it.
- **Exact coverage end date** — drives the effective date and the SEP clock. Never once captured.
- **Height and weight for every adult**, real numbers. Build chart is the underwriting gate.
- **Per-person medication attribution.** Which person each drug belongs to, spelled correctly.
  Mixing these up is the most common real error.
- **Current premium: share vs whole.** Two clients in a row gave their payroll share; the true
  premium was roughly double.
- **Budget as a range, with the ceiling as the value.** "600 to 1000" was captured as 600.

Medical detail stays in POP Pro and the client's Drive folder — only knockout flags reach the CRM.

## Before pushing anything

- `tools/check.sh` (JavaScriptCore; no node on this Mac) — every branch target and section entry
  must resolve to a real card.
- `tools/suite-status.sh` — confirms what GitHub Pages is serving matches local, byte for byte.
- The **wizard's** `check.sh` validates its medications and condition names against this repo's
  `index.html` by absolute path. If a change spans both, **deploy the wizard first.**
- Hooks are already configured in this clone (`core.hooksPath=.githooks`).

Repo was clean and in sync with `origin/main` when these files were added.

## Rules that live only in the Health thread's memory — carry them across

This repo has no memory directory; all of Jesse's project memories sit under the Health
Insurance / optimum-planning-tools project. `CLAUDE.md` already covers suite layout, deploy
order and the checks. These do not appear anywhere in code and would be guessed wrong:

### Client profile — the paper form is the spec
The source of truth is Jesse's paper form, `NEW Client Profile 073124.pdf` (Drive id
`1zl8_QVAnbFmIk1ybZnUF7oHp2h8cyhBH`). Treat it as the field list. **Never add a PII field
without Jesse explicitly asking.**

- **SSN and bank routing/account never go in the tool.** Paper only, destroyed after, or
  straight into the carrier's e-app. **Driver's licence number IS allowed** — he corrected
  this on 2026-09-19. Any brief that lists DL as session-only is out of date on that point.
- **Actual age (last birthday) is correct for quoting.** Age nearest birthday matters only
  for a few IUL carriers, so the wizard's DOB math is right as written.
- **Comp, carrier, policy number, premium and due dates are post-sale admin** — captured
  elsewhere, not on the call sheet.
- **W/P means Work or Private** on existing coverage. Work-only ends with the job — better
  than nothing, still get them protected. Private *term* may not outlast the need, which is
  the opening for permanent. This is inline coaching on the card, not a data field.
- **"What do you want out of the ___" is the why**, not a product placeholder. It's what the
  close leans on.

### Deploy order is a production concern, not a preference
The navigator's Carriers panel iframes `wizard.ffloptimum.com/?embed=1`. Embed mode and the
message listener live in the **wizard**, so the wizard deploys first. The other way round,
the panel shows the full untrimmed wizard, nothing flows, and after ~5s the badge shows `!`.
Both are GitHub Pages — they go live the moment main is pushed.

### Before reporting repo state, run `tools/suite-status.sh`
Twice now a session has reported the repos as broken when the problem was local. A stale
duplicate clone at `~/Documents/script-navigator` once made a session report 52 commits
behind on work that was current.

## Two things currently broken elsewhere in the suite

Neither blocks this work, but both will confuse anyone who touches them:

- **The call-recording pipeline has produced unusable transcripts since 2026-09-22.**
  `callpanel.py` has not changed since 9/21; the audio path did. Recordings since then
  transcribe as hallucinated nonsense and the keyword parser silently emits wrong fields.
- **Google Drive is disconnected in both directions.** The local mount stopped syncing on
  9/19; server-side and local copies of the carrier library have diverged. The mount also
  moved from `~/Google Drive` to `~/Library/CloudStorage/GoogleDrive-…`. There is a resolver
  at `~/Documents/Claude/Projects/Health Insurance/drive-path.sh` that finds the live one.
