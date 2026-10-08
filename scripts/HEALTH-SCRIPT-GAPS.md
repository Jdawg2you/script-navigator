# Health script — what POP Pro's intake needs that the script does not yet ask

Captured 2026-09-24 from Jesse's walkthrough of the POP Pro intake against the live
health discovery script. This is the next body of work on the health script.

Nothing here is built yet. The bridge carries whatever the script captures; these are
the questions the script does not currently ask, so the boxes arrive empty.

---

## 1. Corrections to the existing mapping  (Jesse, 2026-09-24)

| POP Pro field | Was mapped from | Should be |
|---|---|---|
| `budget` ("Max comfortable monthly") | `budget_comfort` | **`budget_max`** — pull the max over; the comfortable figure goes in the notes |
| `invprot` ("Protected") | `asset_prot` | **nothing** — not a direct link. POP Pro's note says most investment accounts are not protected; it is a statement about the account |
| `invsra` ("Eligible for SRA") | — | **`asset_prot`** — eligible for SRA *is* eligible for protection |
| `invnote` ("Investment notes") | `asset_notes` | recap of `asset_where` + `asset_employer` + `asset_notes` |
| `invest` ("Investment accounts") | `asset_amt` | correct — the 401k/IRA amount |
| `savings` ("Liquid savings") | `i_liquid` | correct — directly translatable |

## 2. Questions to ADD to the health script

### Family history — POP Pro has per-person boxes, the script never asks
- Family history of **cancer** (`famcancerP` / `famcancerS`)
- Family history of **heart attack / heart disease** (`famheartP` / `famheartS`)
- Family history of **stroke**
- **Mental health** per person (`mentalP` / `mentalS`) — the script captures Anxiety/
  Depression/PTSD/Bipolar as conditions, but not POP Pro's per-person flag
- **Maternity** — needs maternity coverage (`maternityP` / `maternityS`)

### Coverage wants
- **Dental** and **vision** — asked nowhere in the script

### Current coverage — the whole block is missing
- Current **carrier** (`carrier`)
- **Plan name** (`plan`)
- What they pay now — **premium** (`prem`)
- Do they receive a **subsidy**, as far as they know (`subsidy`)
- Current **deductible** (`ded`)
- Roughly how many **doctor visits** a year (`visits`)
- Approximate **copay** (`copay`)

### Medications — who is each one for
POP Pro's medication rows carry `forP` / `forS` (applicant / spouse). The script's
medication picker captures the drug but not the person. On a household case that
distinction matters. Proposal: a per-person tick beside each medication as it is added.

## 3. Things that deliberately do NOT translate
- `majorcond` — no clean equivalent. Could be derived from the conditions already
  ticked (cancer / terminal / hospice etc.), but it is a judgement call, not a field.
- Anything without a POP Pro box goes to the intake **notes**, which is lossless.
- `routeNote` / `docsNote` are free-text and can absorb overflow if needed.

## 4. Already translating correctly
Surgery (last 2 yrs) · diabetic + insulin/pills + A1C + neuropathy · doctors they want
to keep (name, practice, on-plan, must-keep) · medications · tobacco per person ·
heights, weights, ages, DOBs · incomes and household · liquid savings · retirement age.
