# Handoff — the Health Discovery Call script

**Written 2026-09-24 from the Health Insurance thread. Self-contained.**
This is the reasoning behind `health-discovery.md` and `health-discovery-callsheet.html`.
Read it before converting either into navigator cards, because several decisions look
arbitrary and aren't.

---

## 1. What this is

A discovery script for Jesse's **health** calls — the first call, before POP Pro is filled
and before the presentation is booked. It replaces nothing automatically; three older
scripts exist and all three fed into it.

Two formats, same content:

- **`health-discovery.md`** — the script with its reasoning attached. ★ markers, evidence
  tables, and a cut list. This is the editorial source.
- **`health-discovery-callsheet.html`** — the same script laid out to be read *while on a
  call*. Standalone, no dependencies. This is what Jesse actually uses today.

## 2. Where it came from

Three sources plus Jesse's own recorded calls. None was adopted wholesale.

| Source | What it contributed | What was left |
|---|---|---|
| **Kyle / ManhattanLife, June 2025** (`Kyle Course/ManhattanLife Discovery Call 6_2025.docx`) | The sales craft: the qualifying open, the ACA ten-essential-benefits pitch, build-chart framing for height/weight, the trial close, BAMFAM, asking the coverage **start** date early | Its product-specific routing (Philly, Iron-Health) — out of date |
| **HealthFirst, July 2026** (`~/optimum-crm/hf-discovery-call-script.md`, also Notion `3e069673-987e-81e4-b696-dab791794f4a`) | The discovery spine: Package of Protection framing, retirement and income-protection seeds, the gap-map structure, the data-capture map | Four questions Jesse has never asked — see §5 |
| **Jesse's own additions** (already in the July script) | Ask about dental; ask family history of cancer/heart/stroke, not just the client's own; work-only life counts as a gap | — |
| **Three recorded calls** — Livingston 9/15, Boo 9/21, Cosgriff 9/23 | The flow that actually works, and the evidence for every ★ | — |

There is also a machine version, **`~/optimum-crm/callscripts/health-discovery.json`** — 23
steps, 45 capture fields with regex cues. It drives the live call panel. Its own note says
*"Jesse does not read this in order or verbatim — capture is driven by the per-field cue
keywords, not by step position."* **That is the single most important design fact here.**

## 3. The evidence base

Every section of the July script was checked against what Jesse actually said on two full
recorded calls. The result decided what stayed, what was promoted, and what was cut.

**Always asked, unprompted:** height, weight, tobacco, income this year, dental, vision,
family history, primary doctor, budget.

**Asked inconsistently:** DOB, income next year, mortgage, six-months-no-work, whether the
spouse would attend. Each appeared on one call and not the other.

**Never asked on any call:** the "biggest frustrations" checklist, "did you meet your
deductible last year," disability income protection, "what do you enjoy most about what you
do," and — the important one — **the exact date current coverage ends.**

## 4. The ★ markers — what they are and why they must survive

★ marks something Jesse is **not currently doing**. Each one was chosen because skipping it
cost real work on a real case in September. They are not stylistic; they're the whole point
of the rewrite.

| ★ | Evidence | Consequence |
|---|---|---|
| Exact coverage **end date** | never asked, any call | effective date and SEP clock unknown on Boo and Cosgriff |
| **ZIP**, not state | skipped on Cosgriff | no marketplace comparison possible at all until chased days later |
| Income **next year** + read-back | skipped on Livingston | the number the entire track hangs on, unverified |
| **FPL cliff check, live on the call** | never done | Cosgriff: $1,200/month sat either side of the line, surfaced only afterwards |
| "Is that your **share or the whole premium**?" | Boo, Livingston | both gave their payroll share; true premium was roughly double |
| Real **height and weight**, every adult | Cosgriff ("about 61, maybe 290") | BMI 38 is the underwriting gate and it was a guess |
| **Spouse's DOB** | Cosgriff | a couple's rate is set off the older applicant |
| **Drug name spelled, per person** | Cosgriff ("Alma Sartin" → olmesartan) | took a follow-up call to resolve |
| **Budget = top of range**, read back | Boo ("600 to 1000" → captured 600) | recommendation built a tier low |
| **Spouse on the presentation call** | Livingston | the person who has to agree wasn't there |

### The FPL check is the highest-value item on the sheet
2026 thresholds, 400% of federal poverty level — the point where subsidy stops dead:

| Household | Cut-off |
|---|---|
| 1 | $62,600 |
| 2 | $84,600 |
| 3 | $106,600 |
| 4 | $128,600 |
| 5 | $150,600 |

It is a **cliff, not a slope.** On the Cosgriff case, household of two in Maricopa County AZ:
the same bronze plan with the same $18,000 deductible cost **$1,521.85/month at $100,000 of
household income and $321.85 at $84,000.** She was aiming for $100,000 to fund her husband's
spending. The extra $16,000 of income cost $14,400 in lost credit — she'd have ended up
behind after tax on the withdrawal.

That is why the thresholds are printed inline on the call sheet rather than looked up later.

## 5. What was cut, and the one thing put back

**Cut** — never asked on any recorded call, on usage evidence rather than judgement:
- The "biggest frustrations" checklist (premium / deductible / Rx / network / benefits).
  Question 4, *"was it more the cost, the coverage, or something else?"*, gets the same
  answer in one line.
- "Do you have disability income protection?" — question 11 opens the same door.
- "What do you enjoy most about what you do?" — good rapport in theory, dead in practice.

**Put back after first cutting it:** *"Did you happen to hit that deductible last year?"*
I removed it as unused, then found Kyle's version carries the reason — it isn't a data
question, it's a **pain** question. Acknowledging that you can pay premiums all year and
still owe thousands before the plan does anything builds more trust than any feature. It
survives with the coaching note attached.

## 6. Design decisions in the call sheet that must survive conversion

The HTML isn't decoration. Four things are load-bearing:

1. **The sticky must-ask bar.** Nine chips pinned to the top of the viewport while scrolling.
   The failure mode this fixes is real: Jesse reaches the end of a good call having never
   asked for a ZIP. In card form this needs to be a persistent element, not a card.
2. **The FPL table inline at step 9**, not in an appendix. The check only has value if it
   happens *during* the income question.
3. **Say-this text is large; coaching is small and grey.** On a live call the eye must land
   on the words to speak. Any conversion that flattens this hierarchy makes it unusable.
4. **Linear top-to-bottom order.** Deliberate. The panel note says capture is driven by cue
   keywords, not step position — so the script can be read out of order, but it should
   *look* like one pass.

## 7. What is genuinely unsettled

- **Branching.** The script is mostly linear. The real forks are: *losing coverage → get the
  exact date* · *changing job → new job or retiring* · *spouse exists → will they attend* ·
  *near the FPL line → the income conversation happens now*. Nothing else needs a branch, and
  over-branching a discovery call makes it worse.
- **Whether "ready" should be true on first commit.** The cards will need a live call before
  anyone can say the flow holds. `ready:false` until Jesse has run it.
- **The three cut questions.** Cut on evidence from two calls. Two calls is not a large
  sample. Jesse can put any of them back with a word; the reasoning is recorded so the
  decision is reversible rather than lost.
- **Jesse has not yet used the sheet on a live call.** He asked for it 2026-09-24 for his
  next call and said he'd tweak afterwards. **Expect changes before this is worth converting.**

## 8. One correction this script exists partly to prevent

On the Cosgriff discovery call Jesse said *"I'm gonna recommend a PPO plan… that PPO option,
private network."* These are **fixed-benefit policies, not a PPO.** It's on the never-say
list in the case-builder's `checks.md` §3, and it generated a correction owed in writing.

The right line is: *"no network restriction — any doctor, any hospital, the same benefit,"*
then name the trade, which is that there's no annual out-of-pocket cap. If the script
becomes cards, that phrasing belongs as inline coaching anywhere the client asks about
networks.
