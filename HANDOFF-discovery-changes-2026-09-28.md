# Handoff — health discovery script changes
**From the Health Insurance thread, 28 September 2026.**
Source of truth for the wording: `~/Documents/Claude/Projects/Health Insurance/Optimum_Discovery_Call_Script.md`
(already updated; backup at `.bak`).

**Nothing in this repo has been touched.** Every change below is proposed, with the exact
card and the exact line objects.

---

## Why these changes exist

Four questions were cut from the discovery flow earlier on **usage evidence** — Jesse had
never asked any of them on a recorded call. He has now ruled three of them **back in**, and
one of the four turned out never to have been cut at all.

The rulings came off a reviewed list; they are decisions, not suggestions. Each one below
carries its reason so it does not get quietly reverted later.

---

## 1 · `hs_why` — add the three frustrations

**Card at line ~2877.** After the existing second `ask` and before the `warn`:

```js
{t:"ask",x:"If you had to pick the <b>three biggest frustrations</b> with what you've got right now &mdash; what would they be? ___(frustrations)"},
{t:"do",x:"Let them list all three. Write them down in their words."},
{t:"train",x:"<b>Ask for three, not one.</b> The open question gets their headline reason. This gets the second and third &mdash; usually the ones they have not said out loud to anyone &mdash; and those are what you quote back on the presentation call. Kyle's intake worksheet has printed fields for exactly this."},
```

**New capture field**, in `PF_SPEC_HEALTH` under `{sec:"Why they're looking",id:"why"}`:

```js
{k:"frustrations",l:"Three biggest frustrations",hint:"in their words",type:"area",w:3},
```

---

## 2 · `hs_occupation` — add the rapport question, marked optional

**Card at line ~2932.** After the "how long" ask:

```js
{t:"ask",x:"<i>(optional &mdash; rapport)</i> What do you <b>enjoy most</b> about what you do?"},
{t:"do",x:"Optional. Use it to build rapport, skip it when the call is moving."},
```

🔴 **It must read as optional.** Jesse's ruling, verbatim: *"show as optional and to build
rapport."* Do not give it a `★` or a required capture field.

*It is the only question in the flow that is not extracting something, and it tells you what
they would hate to lose. It sits after the occupation question, not before, because people
answer it honestly once they have already started talking.*

---

## 3 · `hs_current` — two additions

**Card at line ~2904.** After the existing deductible/copay asks:

```js
{t:"ask",x:"And did you actually <b>hit that deductible</b> last year? {{cur_hit_ded}}"},
{t:"do",x:"Acknowledge the sting. Paying a large premium all year and still owing thousands before the plan does anything is a real frustration, and naming it builds more trust than any product feature."},
{t:"ask",x:"Outside of the health plan &mdash; are you paying separately for <b>dental or vision</b> right now, or is that out of pocket? ___(dental/vision spend)"},
{t:"ask",x:"Roughly what does that run you? ___(dental/vision monthly)"},
{t:"warn",x:"<b>This is inventory, not an offer.</b> You are asking what they already spend, exactly as you did for health. <b>Never follow it with &ldquo;would you want me to look at that for you?&rdquo;</b> &mdash; that turns it into an offer and it is the line that was cut."},
```

**New capture fields**, in `PF_SPEC_HEALTH` under `{sec:"What they have now",id:"current"}`:

```js
{k:"cur_hit_ded",l:"Hit the deductible last year?",w:1,opt:["","No","Yes","Doesn't know"]},
{k:"dv_now",l:"Dental / vision now",w:1,opt:["","Out of pocket","Separate plan","Nothing"]},
{k:"dv_spend",l:"What they pay for it",money:"plain",w:1},
```

**Why the spend figure matters:** whatever they pay a dentist today **comes off the table**
when the add-on is offered after the tier is agreed. On the Kelley case that number surfaced
by luck during the presentation and it was the figure that made the break-even land. Capture
it on discovery instead.

---

## 4 · 🔴 There is no income-protection card, and there should be

The health script runs `hs_family` → `hs_occupation` → `hs_qualify`. **The discovery script
has a section 11 (Income Protection) with no card behind it.**

Proposed new card between `hs_occupation` and `hs_qualify`:

```js
hs_income_protection:{s:"3",t:"Income protection",l:[
{t:"ask",x:"If something unexpected kept you from working for six months &mdash; how hard would that be financially?"},
{t:"ask",x:"And do you have <b>anything in place</b> for that &mdash; disability cover through work, or your own policy? {{disability_now}}"},
{t:"train",x:"<b>The first question establishes the pain; the second establishes the gap.</b> Without it you have a feeling. With it you have &ldquo;so there is nothing.&rdquo; Work-only disability leaves when the job does, and for anyone self-employed or 1099 the answer is usually nothing at all."},
{t:"do",x:"This answer sizes the deductible they can actually carry. &ldquo;I don't have that kind of money set aside&rdquo; is the sentence that justifies the whole hospital-indemnity conversation later. It is also the bridge to living benefits."}
],b:[{k:"Move to qualifying",to:"hs_qualify",c:"go"}]},
```

Then change `hs_occupation`'s button target from `hs_qualify` to `hs_income_protection`.

**New capture field**, under a new or existing section:

```js
{k:"disability_now",l:"Disability cover in place?",w:1,opt:["","None","Through work","Own policy"]},
```

---

## 5 · 🔴 `PF_SPEC_HEALTH` — the "Coverage wanted" section now contradicts the rule

Currently:

```js
{sec:"Coverage wanted",id:"wanted"},
{k:"want_dental",l:"Dental",w:1,opt:["","No","Yes"]},
{k:"want_vision",l:"Vision",w:1,opt:["","No","Yes"]},
{k:"want_hearing",l:"Hearing",w:1,opt:["","No","Yes"]},
```

**Asking what they *want* is exactly what was cut.** Dental and vision are offered **after**
the client agrees to a tier, never during discovery — otherwise you are no longer comparing
like-for-like against a marketplace plan, which does not include dental.

**Recommended:** relabel the section so it reads as a post-agreement note rather than a
discovery question — e.g. `{sec:"Add-ons — after the yes",id:"wanted"}` — and leave the
fields for the agent to fill when the add-on is actually offered.

**Jesse should rule on this one.** It is a behaviour change, not just wording.

---

## 6 · 🔴 `hs_startdate` carries a line that is wrong for ManhattanLife

**Card at line ~2921:**

```js
{t:"do",x:"Usually no sooner than 15 days out. Most carriers start on the 1st or the 15th."},
```

**ManhattanLife lets you pick any effective date** — it does not have to be the 1st, and the
portal guidance says **3–5 days**, not 15. Two Manhattan-specific sources say so.

**Jesse's ruling on this (item S11):** *"Try for effective 1 or 15th."* So the **1st/15th
preference stays** — it is the 15-day lead time that is wrong.

Proposed replacement:

```js
{t:"do",x:"Aim for the 1st or the 15th &mdash; that is when most clients get paid. ManhattanLife will accept any date, typically 3&ndash;5 days out, so you are not waiting two weeks."},
{t:"warn",x:"Some states impose a 30-day waiting period for illness coverage. Order a policy for the state you are writing in."},
```

---

## Not changing

- **Section 13's existing deductible question.** *"Did you happen to hit that deductible last
  year?"* was believed cut; it was in the script the whole time. Only the navigator is
  missing it.
- The 25-section structure. Nothing is reordered.
- Any other script in `SCRIPTS`. These changes are `hs_*` only.

## Summary

| | Card | Change |
|---|---|---|
| 1 | `hs_why` | + three frustrations ask, + `frustrations` field |
| 2 | `hs_occupation` | + optional rapport ask — **must read as optional** |
| 3 | `hs_current` | + hit-the-deductible, + dental/vision spend, + 3 fields |
| 4 | **new** `hs_income_protection` | whole card — section 11 has no card today |
| 5 | `PF_SPEC_HEALTH` | "Coverage wanted" → after-the-yes. **Needs Jesse's ruling** |
| 6 | `hs_startdate` | 15-day lead time is wrong for Manhattan |

**Items 5 and 6 are findings, not just transcription** — they were not on the original list
and came out of reading the navigator against the updated script.
