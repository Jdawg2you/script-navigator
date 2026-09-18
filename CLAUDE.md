# Insurance Script Navigator — project notes for Claude Code

Single-file web app (`index.html`, no build step, no dependencies), live at
https://script.ffloptimum.com/ via GitHub Pages (CNAME in the repo root).

**This clone is `~/script-navigator`.** A stale duplicate once lived at
`~/Documents/script-navigator` and made a session report the repo as 52 commits behind work that
was actually current. It is archived at `~/Documents/archive/script-navigator-superseded-2026-09-04`.
Check the path before reporting repo state.

## Before you push
- `tools/check.sh` — parses every `<script>` block with JavaScriptCore (ships with macOS; there is
  no node here), verifies every branch target and section entry resolves to a real card, and fails
  if `restart()` goes back to a hardcoded card id. A missing card number is a **warning**: it only
  shows `?` on the badge and which number to use is an editorial call.
- Enable the pre-commit hook in each clone: `git config core.hooksPath .githooks`
- `tools/suite-status.sh` — for all four suite sites, whether this Mac has uncommitted or unpushed
  work, and whether the page GitHub Pages is serving matches the local file byte for byte. Run it
  when you are unsure whether what you are editing is what agents are using.
- Then load the preview and actually look at it.

## The suite
Four separate repos on four subdomains of ffloptimum.com, so four browser origins: `script`
(this), `wizard`, `tools`, `portal`. Nothing is shared between them by storage — the navigator
feeds the wizard over `postMessage` (`{source:"optimum-suite", type:"client", v:1, client:{…}}`),
which keeps client health answers inside the agent's browser.

The two repos guard each other. The **wizard's** `tools/check.sh` verifies its medications,
condition names and follow-up questions against `~/script-navigator/index.html` by absolute path
and fails when they drift. This repo's check covers this side. Deploy the wizard before the
navigator when a change spans both.

## Known, deliberately not fixed here
- `iul i_h_hipaa` and `iul i_h_knock` have no entry in the IUL `ID` map, so their card-number badge
  shows `?`. They sit before `i_h_build` ("8.1"), so numbering them means either renumbering
  section 8 or inserting before 8.1 — Jesse's call, not a mechanical fix.

## Conventions
- No frameworks, no bundler, no external JS. One file, deploys by copy.
- Script content is ES5-flavoured (`var`, `function`); match what is already there.
- Every `to:` in a branch must name a real card. A typo is a dead button, not an error.
