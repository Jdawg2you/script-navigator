# Health Discovery — the live script

**Generated — do not edit by hand.** Printed from `LIB.health` in `index.html` (`portable` @ abc595d 2026-10-17 + uncommitted changes) by
`node tools/emit-health-md.mjs`. The cards in `index.html` are the script; change them there and regenerate.

Every line of every card, in card-number order. Tags:

- **SAY** / **ASK** — spoken to the client. **DO** / **DO (big)** — an instruction to the agent, on screen.
- **TIP** / **NOTE** / **WARN ★** — boxed guidance on screen. **TRAIN** — training copy only; it is *not* drawn on the call screen.
- **COLLECT** — profile fields filled in on the card (shown when the profile is on). **ON SCREEN** — a capture widget.
- `___(label)` — a blank the agent fills or the profile fills in (see *Blanks* at the end). `[Field: A · B]` — answer chips.
- _only when …_ — the line or button appears only when that answer holds.

## Stages

- **1 · Start** — sections 1 Appointment or Warm (starts at 1.1)
- **2 · Open** — sections 2 The Open (starts at 2.1)
- **3 · Discovery** — sections 3 The Household (starts at 3.1), 4 Qualify (starts at 4.1), 5 Health (starts at 5.1)
- **4 · Money** — sections 6 Money (starts at 6.1)
- **5 · Book** — sections 7 Book It (starts at 7.1)

The call opens at 1.1 Which call is this? (`hs_start`).

---

## 1 · Appointment or Warm

_Decide which call this is, and either start it or book it._

### 1.1 · Which call is this?  `hs_start`

_Card: reaching it clears `did_discovery`._

- **DO** — Pick before you dial. It changes the first thirty seconds and nothing after them.

**Which is it?**

- [They booked an appointment] → 2.1 Open (`hs_open`)
- [Warm call — they requested info] → 1.2 Warm reach-out (`hs_warm`)

### 1.2 · Warm reach-out  `hs_warm`

_Card: opens the profile at *Who you're calling*._

- **SAY** — Hi ___(first name)? This is ___(your name) — I'm reaching out because you'd originally requested some information about private health options.
- **SAY** — I wanted to get back to you and see how we can best help you out.
- **ASK** — I've got your date of birth as ___ — is that right?
- **DO** — Confirm one thing you already have. It proves the request was real and it earns the next sixty seconds.
- **TRAIN** — They did not book this call, so the first objection lands here rather than later. Handle it and keep going, or book it properly — do not push a discovery call into a bad moment.

**How does it land?**

- [Good — keep going now] → 1.2a They'll talk now (`hs_warm_yes`)
- [Not a good time — book it] → 1.2b Book it instead (`hs_warm_book`) · _alert_

### 1.2a · They'll talk now  `hs_warm_yes`

- **SAY** — Perfect — this'll only take a few minutes, and I'll tell you straight away whether I can help.
- **DO** — Go straight into the open. You have already confirmed who they are, so skip the verification there.

**Buttons**

- [Into the call] → 2.2 Qualify first (`hs_qualify_first`)

### 1.2b · Book it instead  `hs_warm_book`

- **SAY** — No problem at all — let's get a proper time on the calendar so I'm not rushing you.
- **DO** — Do not try to salvage it into a discovery call. A booked call with the right people on it beats a half call now.

**Buttons**

- [Set the time] → 1.3 Two times (`hs_book_times`)

### 1.3 · Two times  `hs_book_times`

- **TIP** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — **Book it for today — ideally the next 10 to 15 minutes.** Everything is built in this tool, so that's all the time you need, and the closer the follow-up, the warmer the close. Later tonight if you have to. Tomorrow is the last resort.
- **SAY** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — Give me about fifteen minutes to put your options together — can I call you right back at ___(time A)? … If that's tight, how about later today at ___(time B)?
- **SAY** _only when Full discovery done (set at 7.1) (`did_discovery`) is not answered or “No”; also shown before it is answered_ — Let's look at tomorrow — would during the day or the evening be better for you?
- **DO** — Let them pick the half of the day. You are narrowing, not offering a blank calendar.
- **ASK** _only when Full discovery done (set at 7.1) (`did_discovery`) is not answered or “No”; also shown before it is answered_ — Okay — I have ___(time A) or ___(time B). Which is better for you?
- **WARN ★** — **Two times, from your own calendar, in their time zone.** You captured their ZIP at qualification, so you know which one that is. Never ask “when are you free?”

**Buttons**

- [They have a spouse or partner] → 1.3a Who else needs to be on it (`hs_book_who`)
- [Just them] → 1.3b Lock it in (`hs_book_lock`)

### 1.3a · Who else needs to be on it  `hs_book_who`

_Card: opens the profile at *Who you're calling*._

- **ASK** — Would you like your ___(spouse or partner) to be with you for the presentation call?
- **SAY** — The reason I ask is that I don't want to put you in a position where you have to re-explain everything we covered. That wouldn't really be fair to you — they'll have questions, and you wouldn't have the answers to hand. I'd rather give them the chance to ask me directly.
- **ASK** — So — would you like them on the appointment as well?
- **COLLECT** — Who else is on it (`appt_who`)

**What do they say?**

- [Either way — lock it in] → 1.3b Lock it in (`hs_book_lock`)

### 1.3b · Lock it in  `hs_book_lock`

- **SAY** — I just want to make sure you have my full name — ___(your name).
- **SAY** — Please block off about 15 minutes on either side, in case I'm running early or behind.
- **SAY** — I'm going to send you a text message confirmation — is ___(phone) the best number? When that comes through, if you can just reply with a yes or a thumbs up, so I know you received it.
- **DO** — Send the text now, while they're still on the phone. Not after.
- **SAY** — Now, I do have one request that I'd like to make.
- **DO** — Micro-pause. Let them say “sure”. The pause is what turns this from a throwaway line into a commitment.
- **SAY** — *“If anything comes up, would you do me the courtesy of letting me know as soon as possible? I'd hate to be sitting there waiting for our call, getting sucked into TikTok. So if something changes, just let me know and I'll move our time to what works better. Is that fair?”*
- **TIP** — Say it however it comes out of your mouth — the words are not the point. The point is that they hear our time is worth something too. That is what turns a booking into a kept appointment.
- **DO** — Wait for the yes. That yes is the appointment.
- **SAY** — And just so you know, we won't be committing to anything on that call. What I'll do is break it all down so you're completely clear, and then you'll tell me which direction you'd like to go from there.
- **ASK** — Real quick — what time do you have us down for?
- **ON SCREEN** — Appointment picker: Appointment date · Appointment time
- **DO** — Make them say it back. That is what makes appointments hold.

**Buttons**

- [Wrap up client for next steps] → 1.3c After the booking (`hs_book_end`)

### 1.3c · After the booking  `hs_book_end`

- **NOTE** — Log it, send the confirmation text, set your own reminder. Call back at the exact time you promised.
- **DO (big)** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — You have a full profile on this one. Don't let it die in the browser tab.
- **SAY** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — **Save it, then push it over.** Saving keeps a copy on record and gives you a file you can reload before the presentation call — so you walk in already knowing their medications, their doctors, their income and their number.
- **ON SCREEN** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — Buttons: Save the profile · Print the profile · Push client to MyPopPro
- **DO** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — Save first, every time. Once it is saved, open MyPopPro and start building the good / better / best while the call is still fresh.
- **TRAIN** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — **The presentation is built before the call, not on it.** If you open MyPopPro cold at the appointment time you will spend the first ten minutes typing what they already told you, and they will hear it.
- **WARN ★** _only when Full discovery done (set at 7.1) (`did_discovery`) is “Yes”_ — The saved file lives in your downloads folder, not in this browser. It has health information in it — keep it where you keep client paperwork, and don't email it around.

**Buttons**

- [Back to the start] → 1.1 Which call is this? (`hs_start`)

---

## 2 · The Open

_Earn the right to ask, and find out why they are shopping._

### 2.1 · Open  `hs_open`

_Card: opens the profile at *Who you're calling*._

- **SAY** — Hi, ___(first name) ___(last name)? [Gender: Male · Female]
- **DO** — Pause. Get confirmation it's them before you keep going. The last name is for spelling checks later — it only needs typing once.
- **SAY** — Hi ___(first name) — this is ___(your name) with ___(your agency). We have the appointment for the private health insurance. How are you today?
- **DO** — Pause.
- **SAY** — *Optional — (is this still a good time to connect?)*

**Buttons**

- [Next] → 2.2 Qualify first (`hs_qualify_first`)

### 2.2 · Qualify first  `hs_qualify_first`

- **SAY** — Before I get into who we are and the boring stuff — I need to see if we can even help you out.
- **ASK** — Have you already found a really good plan that's affordable for you, or are you still looking?
- **DO** — Ask this before the credibility block. If they're already covered and happy, you've both saved twenty minutes.

**What do they say?**

- [Still looking] → 2.3 Set the tone (`hs_tone`)
- [They found something great] → 2.2a "I already found something great" (`hs_found`) · _alert_

### 2.2a · "I already found something great"  `hs_found`

_Card: opens the profile at *Why they're looking*._

- **SAY** — That's genuinely good to hear — most people I speak to haven't.
- **ASK** — So I'm not wasting your time: what did you land on, and what are you paying for it?
- **COLLECT** — Plan they already found (`found_plan`)
- **DO** — Write down what they say. You are deciding in the next thirty seconds whether there is a reason to keep going, and if there isn't you end the call cleanly and quickly.
- **TRAIN** — **Do not argue with their plan.** They just told you they solved the problem you rang about. Arguing makes you the pushy agent. The only honest reasons to keep talking are that something is *missing*, not that what they have is bad.
- **DO (big)** — Four things worth one question each. Stop at the first no.
- **NOTE** — **1 · Is it actually in force?** “Has it started yet, or does it kick in later?” A plan they have chosen but not started is still a plan you can compare.
- **NOTE** — **2 · Is the whole household on it?** “Does that cover everyone, or just you?” A spouse or child left off is the most common gap.
- **NOTE** — **3 · Dental and vision.** “Did they include dental and vision, or is that separate?” Almost never included, cheap to add, and it is a real gap rather than a pitch.
- **NOTE** — **4 · The rest of the picture.** “While I've got you — is anything in place if you couldn't work for a few months? Life cover? Anything for retirement?” This is the Package of Protection conversation and it is the reason the call was worth making.
- **WARN ★** — **If all four come back covered, end it and mean it.** “Honestly, it sounds like you're in good shape — I'm not going to try to sell you something you don't need. If anything changes, keep my number.” You will get referrals from that call. You will not get them from the other kind.

**Where did that land?**

- [There's a gap — keep going] → 2.3 Set the tone (`hs_tone`)
- [They're genuinely covered — end well] → 2.2b Ending it well (`hs_found_end`)

### 2.2b · Ending it well  `hs_found_end`

- **SAY** — Honestly — it sounds like you're in good shape, and I'm not going to try to sell you something you don't need.
- **SAY** — Do me one favour though: keep my number. If anything changes with the plan, or with work, or if anyone you know is stuck on this — I'd rather be the person you call than the one you have to go looking for.
- **DO** — Log it honestly. A clean no today is worth more than a bad fit you spend three months servicing.

**Buttons**

- [Back to the start] → 1.1 Which call is this? (`hs_start`)

### 2.3 · Set the tone  `hs_tone`

- **SAY** — Before we dive in, let me tell you a little about who I am and how I work.
- **SAY** — I'm a licensed health insurance agent, and I also help families with life insurance, retirement planning and a number of other financial services. What I do is find out what's important to you, so we can tailor a plan that actually accomplishes your goals. There are a lot of companies and a lot of products out there, and they don't all do the same thing, so it matters who you work with. I'm not beholden to any one company. If one company is the best fit for you, I want to have compared it against all the A-rated ones first. _(the default bio — the agent's own bio from Set up replaces this)_
- **DO** — That's **your bio**, from Set up. Say it in your own words — what matters is that they hear you're not tied to one company, so you can be trusted to compare. Change it any time; empty means the default.
- **SAY** — So most agents will try to sell you a policy right away. We look at your whole situation and put together a **Package of Protection**.
- **SAY** — That doesn't mean more insurance. It means making sure there are no financial risks sitting right in front of you that could hurt you or your family.
- **SAY** — Which is why I'm going to ask you some questions that aren't only about your health — some are about your finances. Here's why, so it doesn't come out of nowhere. I'll be looking at several plans for you. Some carry a deductible and some don't. If I recommend one with a $10,000 deductible and it turns out you don't have $10,000 sitting spare, I've just put you somewhere that could throw you into a tailspin — and that would be my fault, not yours.
- **SAY** — So the money questions aren't to sell you anything today. They're so what I recommend actually fits. Does that make sense?
- **TRAIN** — **This buys you the income and savings questions later.** Say it now and they're expected; skip it and section 6 sounds nosy. Keep the $10,000 a *plan* figure — the moment it sounds like you think *they* have a $10,000 problem, the sentence changes character. (Jesse's bootcamp framing, 17 Oct.)

**Buttons**

- [Next] → 2.4 Why they're shopping (`hs_why`)

### 2.4 · Why they're shopping  `hs_why`

_Card: opens the profile at *Why they're looking*._

- **ASK** — So what made you start looking?
  - Fold-out ▸ **Ideas to keep them talking**
    - Was it the cost — what you pay each month?
    - Or what it covers — the deductible, what you end up paying anyway?
    - Did the rate go up this year?
    - A claim that didn't pay, or a bill you didn't expect?
    - A doctor who isn't in the network?
    - Or is it changing — losing it through work, a new job, a move, a baby?
- **COLLECT** — Their why — in their words (`why_matters`) · What's behind it (`why_tags`): (pick any) Too expensive · Deductible too high · Losing coverage · No coverage now · Doctor / network · Life change · Other
- **COLLECT** _only when What's behind it (`why_tags`) includes “Other”_ — Other — what is it? (`why_other`)
- **DO** — Type **their exact words** — “healthcare has just gotten so flippin' expensive” — then click whatever is behind it. On the presentation you quote them: *“Last time we talked, you said …”*. Whatever they say, they're right. Agree.
- **ASK** — And when you picture the right plan for you — what's most important?
- **COLLECT** — Their story — for you, not read back (`why_note`)
- **DO** — Anything more they tell you goes in **their story** — it's for you, not read back. If this answer says it better than the first one, put their words in the **why** box instead.

**What did they say?**

- [Cost, coverage or something else] → 2.4b What they have now (`hs_current`)
- [They're losing coverage] → 2.4a Losing coverage (`hs_why_losing`) · _alert_
- [They have no coverage] → 2.5 The differentiator (`hs_diff`)

### 2.4a · Losing coverage  `hs_why_losing`

_Card: opens the profile at *What they have now*._

- **SAY** — I understand that you're losing your coverage. Let me understand what you've been used to.
- **DO** — Past tense throughout, and keep it short — you need what it cost and what they'd lose, not the whole plan. (Jesse, 16 Oct)
- **ASK** — What were you paying for it out of pocket? ___(they pay)
- **ASK** — And was your employer putting in on top of that? ___(employer pays) — so the real cost is ___(total cost).
- **DO** — The employer's share is the number that makes a private plan look reasonable later: they were paying $400, but $1,000 was going into that coverage every month.
- **ASK** — What's the deductible on it? ___(deductible)
- **ASK** — Anything else about it I should know? ___(what was missing)
- **SAY** — **Now — a couple of practical things.**
- **ASK** — Is it a done deal that you're losing it? [Losing coverage — done deal?: Yes · No]
- **ASK** — And when's your last day of coverage? ___(last day of cover)
- **WARN ★** — **The date, not the month.** It sets the effective date and the enrolment clock. It was never asked on Boo or Cosgriff and both cases stalled on it.

**Buttons**

- [Next] → 2.5 The differentiator (`hs_diff`)

### 2.4b · What they have now  `hs_current`

_Card: opens the profile at *What they have now*._

- **SAY** — Okay — before I show you anything, let me understand what you've got, so I'm comparing like for like.
- **ASK** — Who's your current carrier? ___(current carrier) — and do you know what the plan's called? ___(plan name)
- **ASK** — What are you paying for that out of pocket? ___(they pay)
- **ASK** — And you're still paying that today — it hasn't ended? [Paying for it right now?: Yes · No]
- **ASK** — And do you know what your employer puts in on top of that? ___(employer pays) — so the real cost is ___(total cost).
- **DO** — The employer's share is the number that makes a private plan look reasonable later. Most people have never added the two together.
- **ASK** — What's the deductible on it? ___(deductible) — and the most you could pay in a year, the out-of-pocket max? ___(out-of-pocket max)
- **ASK** — Is that a marketplace plan — through healthcare.gov? [Marketplace (ACA) plan?: No · Yes]
- **COLLECT** _only when Marketplace (ACA) plan? (`cur_is_aca`) is “Yes”_ — Subsidy they get now (`cur_subsidy`)
- **ASK** — Do you have an HSA with it? [Have an HSA?: No · Yes]
- **ASK** — Roughly how many times a year do you end up at the doctor? ___(visits a year) — and is there a copay? ___(copay)
- **TRAIN** — **You are building the comparison now, not at the presentation.** Deductible, visits and copay are what turn “my premium is $420” into what they actually spend in a year. Without them you are comparing your plan against a number they half remember.
- **DO** — If they don't know a number, write what they said and move on. You are not auditing them, and a guess you can check beats a silence.

**Buttons**

- [Next] → 2.5 The differentiator (`hs_diff`)

### 2.5 · The differentiator  `hs_diff`

- **SAY** — I work with a lot of self-employed people frustrated with what healthcare costs. Every marketplace plan — ACA, Obamacare, same thing — has to carry all ten essential benefits.
  - Fold-out ▸ **The 10 essential benefits**
    1. Outpatient care — doctor visits without being admitted
    2. Emergency services
    3. Hospitalization — surgery and overnight stays
    4. Pregnancy, maternity and newborn care
    5. Mental health and substance use disorder services
    6. Prescription drugs
    7. Rehabilitative and habilitative services and devices — physical, speech and occupational therapy
    8. Lab services
    9. Preventive and wellness services, and chronic disease management
    10. Pediatric services, including dental and vision for children
    
    _Source: HealthCare.gov, “What Marketplace health insurance plans cover”._
- **SAY** — Most people don't need all ten. If you're not planning on having a baby, why pay for maternity — one of the most expensive things a plan can cover? So I tailor a plan around what you actually use.
- **WARN ★** — **Never call these PPO plans.** They're fixed-benefit policies. Say “no network restriction — any doctor, any hospital, the same benefit”, then name the trade: there's no annual out-of-pocket cap.

**Buttons**

- [Next] → 2.6 Start date (`hs_startdate`)

### 2.6 · Start date  `hs_startdate`

- **ASK** — Assuming we get you qualified — when would you want your coverage to start? ___(start date)
- **DO** — Usually no sooner than 15 days out. Most carriers start on the 1st or the 15th.
- **TRAIN** — **Ask it even when you think you know.** If they're losing cover you'll assume they want it the day after, and you'll often be right. But some are on a spouse's plan for a month, some are waiting on a new job's cover, some want it lined up with a birthday. Asking costs a sentence; assuming wrong costs the effective date. / / Ask it forward: *“so we line this up right — when would you want it to start?”* reads as planning.

**Buttons**

- [Move to the household] → 3.1 Family (`hs_family`)

---

## 3 · The Household

_Who is in the household and what they do for a living._

### 3.1 · Family  `hs_family`

_Card: opens the profile at *Who you're calling*._

- **ASK** — Tell me about your family. Married, single, children, grandchildren? Anyone financially dependent on you? [Married?: Married · Partnered · Single · Widowed · Divorced] Dependents / kids: [Children: 1 · 2 · 3 · 4+]
- **DO** — You want the shape of the household here, not the detail. Names, dates of birth and the rest come at 4.2 in one pass, where they belong.

**Buttons**

- [Next] → 3.2 Occupation (`hs_occupation`)

### 3.2 · Occupation  `hs_occupation`

_Card: opens the profile at *Money*._

- **ASK** — What kind of work do you do? ___(type of work)
- **ASK** — And how long have you been doing that? ___(how long)
- **ASK** — `Optional · read the room` Does your work offer health coverage? [Health coverage offered through their work?: No · Yes]
- **ASK** _only when Married? (`married`) is “Married” or “Partnered”_ — `Optional · read the room` And your spouse's work? [Through their spouse's work?: No · Yes]
- **DO** — Ask these only if it makes sense. Skip them when you already know — they're losing coverage through work, they're retired, or they work for themselves.
- **DO** _only when Health coverage offered through their work? (`emp_offer`) is “Yes”, **or** Through their spouse's work? (`sp_emp_offer`) is “Yes”_ — An affordable work plan can take away the marketplace subsidy, so note whose job it is and roughly what it would cost them.
- **TRAIN** — **This is not small talk.** What they do decides how much risk sits outside the health plan. An office job and a power-line job carry the same health premium and completely different exposure — accident cover, disability, workman's comp. You're listening for the gap you'll name on the presentation.
- **DO** — If they're changing jobs or retiring, follow it. It moves the timeline and usually the income.

**Buttons**

- [Move to qualifying] → 4.1 Qualification (`hs_qualify`)

---

## 4 · Qualify

_The facts that decide which plans they can actually buy._

### 4.1 · Qualification  `hs_qualify`

_Card: opens the profile at *Qualify*._

- **SAY** — So I know which private plans you may qualify for —
- **ASK** — what's your zip code? ___(zip) — and that's ___(state), right?
- **ASK** — Your date of birth? ___(DOB) — so that makes you ___(age).
- **ASK** — Height and weight? ___(height) ___(weight)
- **ASK** — And do you use any tobacco products? [Tobacco: No · Yes]

**Buttons**

- [On to the household] → 4.2 Household (`hs_household`) · _only when Married? (`married`) is “Married” or “Partnered”_
- [On to the household] → 4.2 Household (`hs_household`) · _only when Children (`kids`) is “1” or “2” or “3” or “4+”_
- [On to health] → 5.1 Health history (`hs_history`) · _only when Married? (`married`) is “Single” or “Divorced” or “Widowed” or not answered, **and** Children (`kids`) is not answered or “0”_

### 4.2 · Household  `hs_household`

- **ASK** — Now let me grab a little more information about the members of your household.
- **SAY** _only when Married? (`married`) is “Married”_ — **And your spouse —**
- **SAY** _only when Married? (`married`) is “Partnered”_ — **And your partner —**
- **ASK** _only when Married? (`married`) is “Married” or “Partnered”_ — Name? ___(spouse first name) ___(spouse last name) [Gender: Male · Female] — date of birth? ___(spouse DOB), so that's ___(spouse age).
- **ASK** _only when Married? (`married`) is “Married” or “Partnered”_ — Height and weight? ___(spouse height) ___(spouse weight) — and tobacco? [Tobacco: No · Yes]
- **SAY** _only when Children (`kids`) is “1” or “2” or “3” or “4+”_ — **Okay — now on to the kids.**
- **ON SCREEN** _only when Children (`kids`) is “1” or “2” or “3” or “4+”_ — Children: name, date of birth, gender for each
- **DO** — Name, date of birth and gender for each child — the age works itself out. No height, weight or tobacco; those only rate the adults.
- **ASK** _only when Children (`kids`) is “1” or “2” or “3” or “4+”_ — And your kids' health — all good there? Any medications?
- **COLLECT** _only when Children (`kids`) is “1” or “2” or “3” or “4+”_ — Kids — health, medications, anything to know (`kids_health`)
- **DO** _only when Children (`kids`) is “1” or “2” or “3” or “4+”_ — One open question, not a health history each. You are listening for anything that changes which plan the family can go on — asthma, an inhaler, a specialist they see. Type what they say.

**Buttons**

- [Move to health] → 5.1 Health history (`hs_history`)

---

## 5 · Health

_Health history, in enough detail to underwrite._

### 5.1 · Health history  `hs_history`

_Card: opens the profile at *Health*._

- **SAY** — Now a few health questions, so I know what you'll actually qualify for.
- **ASK** — Are you on any medications right now?
- **ON SCREEN** — Medication entry
- **TIP** — Type them here and they land on the profile. It knows brand names and copes with a rough spelling. Working off paper instead? Just write them down.
- **ON SCREEN** — Follow-up questions for the conditions the medications point to
- **DO** — The medications tell you the conditions. Answer the follow-ups they raise — you do not need to read a list of illnesses at someone.
- **WARN ★** — **Spell them, per person.** “Alma Sartin” turned out to be olmesartan and cost a follow-up call on the Cosgriff case.
- **ASK** — And one I ask everybody — are you on any of the weight-loss or diabetes injections? Ozempic, Wegovy, Mounjaro, Zepbound, Saxenda, anything in that family? [On a GLP-1 now?: No · Yes]
- **ASK** _only when On a GLP-1 now? (`glp1`) is “Yes”_ — Which one is it? ___(which GLP-1) — and is that for the diabetes, or for the weight? [For what: Diabetes · Weight loss · Both]
- **ASK** _only when On a GLP-1 now? (`glp1`) is “Yes”_ — How long have you been on it? ___(how long on it)
- **ASK** _only when On a GLP-1 now? (`glp1`) is “Yes”_ — And what are you paying for it a month? ___(what the GLP-1 costs)
- **ASK** _only when On a GLP-1 now? (`glp1`) is “Yes”_ — And where do you get it — the pharmacy, one of the telehealth outfits, or is it compounded? [Where they get it: Pharmacy · Telehealth · Compounded · Other]
- **DO** _only when On a GLP-1 now? (`glp1`) is “Yes”_ — Worth asking plainly, and nobody minds the question. A telehealth or compounded script often is not in the pharmacy record the carrier pulls, so it can be missing from their history entirely — and compounded does not read the same way as a branded prescription. You are recording what is true, not judging where they got it.
- **DO (big)** — **Ask it by name, even when they have just told you they take nothing.** This is the medication people leave out most often, and it is usually not deliberate: a lot of it is paid cash or comes from a compounding pharmacy, so it never felt like a prescription — and someone taking it for weight rather than diabetes frequently does not count themselves as being on medication at all.
- **WARN ★** _only when On a GLP-1 now? (`glp1`) is “Yes”_ — **Why you ask it flat, and what not to do with the answer.** It is a live underwriting question on the medically underwritten plans, and the indication matters — diabetes and weight are not read the same way, which is why you ask which one. Write down what they say and carry on. Do not react to it, do not advise them about the drug, and **never suggest stopping or pausing it before an application**. That is a medical decision, it is not yours to make, and advising it is the kind of thing that ends a licence.
- **ASK** — And aside from what we've covered already — are there any other health conditions I should know about? ___(anything else about their health)

**Buttons**

- [Next] → 5.2 Recent history (`hs_conds`)

### 5.2 · Recent history  `hs_conds`

_Card: opens the profile at *Health*._

- **ASK** — In the last two years, any surgeries? [Surgery or overnight stay, last 5 yrs: No · Yes]
- **ASK** _only when Surgery or overnight stay, last 5 yrs (`recent_stay`) is “Yes”_ — What was that for? ___(what for)
- **ASK** — And any hospital stays in the last two years? [Hospital stay, last 2 yrs: No · Yes]
- **ASK** _only when Hospital stay, last 2 yrs (`hosp_stay`) is “Yes”_ — What was that for? ___(hospital stay)
- **NOTE** — **Standing rule on every yes:** when was it, what was it for, and what are they taking for it now.

**Buttons**

- [Next] → 5.2a Family history and general (`hs_famhist`)

### 5.2a · Family history and general  `hs_famhist`

_Card: opens the profile at *Family history and general*._

- **SAY** — A few quick yes or no questions — these change which plans are worth quoting.
- **ON SCREEN** — Yes/no grid: Family history — cancer · Family history — heart · Family history — stroke · Mental health needs (applicant and spouse)
- **DO** — Family history, not their own diagnosis. Their own conditions you already have.
- **ASK** — Is anyone pregnant right now? And is there any chance anyone could become pregnant in the next couple of years?
- **ON SCREEN** — Yes/no grid: Pregnant now · Future maternity needs (applicant and spouse)
- **TRAIN** — **Maternity is the expensive one.** A plan without it is materially cheaper, and putting someone on a plan that excludes it when they are planning a family is the single worst outcome here. Ask it plainly, of both of them.

**Buttons**

- [Next] → 5.3 Doctors to keep — and coverage wanted (`hs_recent`)

### 5.3 · Doctors to keep — and coverage wanted  `hs_recent`

_Card: opens the profile at *Health*._

- **ASK** — Are there any doctors you'd really like to keep, if we can? [Doctors they want to keep?: No · Yes]
- **ON SCREEN** _only when Doctors they want to keep? (`keep_docs`) is “Yes”_ — Doctors to keep: name, must-keep, checked with their plan
- **TRAIN** _only when Doctors they want to keep? (`keep_docs`) is “Yes”_ — **The name is not the point. “Must keep” is.** If a doctor is a hard requirement that decides whether a network plan is even on the table, before you quote anything. If they're relaxed about it you have far more room.
- **DO** _only when Doctors they want to keep? (`keep_docs`) is “Yes”_ — They usually have not checked whether that doctor takes their ACA plan. “Not checked” is a real answer — record it rather than guessing.
- **SAY** — **And while we're here —**
- **ASK** — Would you like me to look into dental coverage for you? [Dental: No · Yes]
- **ASK** — Vision? [Vision: No · Yes]
- **ASK** — And hearing? [Hearing: No · Yes]
- **DO** — Three quick asks. They cost nothing here and they are the easiest thing to add to a package later.
- **ASK** — Is anything planned in the next year — a surgery, a baby, a procedure? ___(planned next year)

**Is there a spouse or partner on the plan?**

- [Do their spouse’s / partner’s health history] → 5.4 Spouse health history (`hs_sp_history`) · _only when Married? (`married`) is “Married” or “Partnered”_
- [Skip spouse health — move to income] → 6.1 Income and the cliff (`hs_income`) · _only when Married? (`married`) is “Married” or “Partnered”_
- [Move to income] → 6.1 Income and the cliff (`hs_income`) · _only when Married? (`married`) is “Single” or “Divorced” or “Widowed” or not answered_

### 5.4 · Spouse health history  `hs_sp_history`

_Card: opens the profile at *Spouse health*._

- **SAY** — Now the same few questions about ___(spouse first name), so I know what they'll qualify for.
- **ASK** — Is ___(spouse first name) on any medications right now?
- **ON SCREEN** — Medication entry — spouse's list
- **TIP** — This is a separate list from yours. What goes in here is recorded as the spouse's, which is how the plan gets rated on the right person.
- **ON SCREEN** — Follow-up questions for the conditions the medications point to — spouse
- **DO** — Same rule as before — the medications tell you the conditions. Answer the follow-ups they raise. The full condition list is on the profile if you need it; you do not read it at someone.
- **WARN ★** — **Spell them, per person.** It matters twice as much here: a medication logged against the wrong person rates the wrong life.
- **ASK** — And the same one I asked you — is ___(spouse first name) on any of the weight-loss or diabetes injections? [On a GLP-1 now?: No · Yes]
- **ASK** _only when On a GLP-1 now? (`sp_glp1`) is “Yes”_ — Which one? ___(which GLP-1 for the spouse) — for the diabetes or the weight? [For what: Diabetes · Weight loss · Both] … How long? ___(how long the spouse has been on it)
- **ASK** _only when On a GLP-1 now? (`sp_glp1`) is “Yes”_ — What do they pay a month for it? ___(what the spouse pays for it) — and where do they get it? [Where they get it: Pharmacy · Telehealth · Compounded · Other]
- **DO (big)** _only when On a GLP-1 now? (`sp_glp1`) is “Yes”_ — **Ask it separately, do not carry the answer across from the applicant.** One of them on Ozempic for diabetes and the other on Wegovy for weight is an ordinary pairing, not an edge case — and the two answers go to different places. Recording them as one household answer gets one of the two people the wrong plan.
- **ASK** — And aside from what we've covered — any other health conditions for ___(spouse first name)? ___(spouse anything else)

**Buttons**

- [Next] → 5.5 Spouse recent history (`hs_sp_conds`)

### 5.5 · Spouse recent history  `hs_sp_conds`

_Card: opens the profile at *Spouse health*._

- **ASK** — In the last two years, any surgeries for ___(spouse first name)? [Surgery, last 2 yrs: No · Yes]
- **ASK** _only when Surgery, last 2 yrs (`sp_recent_stay`) is “Yes”_ — What was that for? ___(spouse what for)
- **ASK** — And any hospital stays in the last two years? [Hospital stay, last 2 yrs: No · Yes]
- **ASK** _only when Hospital stay, last 2 yrs (`sp_hosp_stay`) is “Yes”_ — What was that for? ___(spouse stay what)
- **NOTE** — **Standing rule on every yes:** when was it, what was it for, and what are they taking for it now.
- **TRAIN** — **Doctors, dental, vision and hearing were asked once, for the household.** If the spouse has a doctor they want to keep that you have not recorded, go back to 5.3 and add them — that list is shared.

**Buttons**

- [Move to income] → 6.1 Income and the cliff (`hs_income`)

---

## 6 · Money

_Income, the subsidy cliff, and what they can genuinely afford._

### 6.1 · Income and the cliff  `hs_income`

_Card: opens the profile at *Money*._

- **SAY** — Okay — and this is the part I flagged at the start, where I look at the whole picture.
- **ASK** — Roughly what will your income be this year? ___(your income)
- **COLLECT** _only when Married? (`married`) is “Married” or “Partnered”_ — Spouse income (`sp_income`)
- **COLLECT** — Household income (`hh_income`)
- **ASK** — And is next year going to look about the same, or different? [Next year: Same · Different]
- **COLLECT** _only when Next year (`next_same`) is “Different”_ — Income next year (`income_next`) · Spouse income next year (`sp_income_next`) · Household next year (`hh_income_next`)
- **ASK** — Have you given any thought to a target age for retirement? ___(your retirement age)
- **COLLECT** _only when Married? (`married`) is “Married” or “Partnered”_ — Spouse retirement age (`sp_retire`)
- **SAY** — Some plans carry high deductibles — I'll steer you away from those, but I do want to know what's behind you if something big happened.
- **ASK** — Do you have liquid savings — something like six months put aside if there were an emergency? [Liquid savings?: No · Yes]
- **ASK** _only when Liquid savings? (`has_liquid`) is “Yes”_ — Roughly how much? ___(approximate savings)
- **ASK** — And is there anything else that acts like an insurance policy for your finances? A 401(k), a TSP, an IRA, savings? [Anything that acts like insurance?: No · Yes]
- **COLLECT** _only when Anything that acts like insurance? (`has_assets`) is “Yes”_ — Where is it (`asset_where`) · Roughly how much (`asset_amt`)
- **DO** _only when Anything that acts like insurance? (`has_assets`) is “Yes”_ — Ask the amount **dismissively** — “got it, and about how much is in there?” — and keep moving. The next question is the one that matters.
- **ASK** _only when Anything that acts like insurance? (`has_assets`) is “Yes”_ — Now — is that in a **protected position**, or is it still at **market risk**? [Protected or at market risk?: Protected · Market risk · Not sure]
  - Fold-out ▸ **If they ask what you mean by protected**
- **DO** _only when Anything that acts like insurance? (`has_assets`) is “Yes”_ — They usually don’t know what “protected position” means — but they know *protected* and they know *risk*. Whatever they say, note it and move on. **Don’t fix it today**: you’re planting it for a later conversation, not selling an annuity on a health call.
- **COLLECT** _only when Anything that acts like insurance? (`has_assets`) is “Yes”_ — Where is it held (`asset_employer`): Current employer · Previous employer · They hold it themselves · Mixed
- **ASK** — Any life insurance in place right now — including through work? ___(life insurance now)
- **COLLECT** _only when Anything that acts like insurance? (`has_assets`) is “Yes”_ — Protectable? (`asset_prot`): Yes · No · Notes on their money / details (`asset_notes`)
- **TRAIN** — **You are not selling any of this today.** You are finding out whether a big medical bill would land on savings, on a retirement account, or on nothing at all. That answer is what the Package of Protection conversation is built from on the presentation call.

**Buttons**

- [Next] → 6.2 Bank (`hs_budget`)

### 6.2 · Bank  `hs_budget`

- **ASK** _only when What's behind it (`why_tags`) includes “Losing coverage”, **or** What's behind it (`why_tags`) includes “No coverage now”_ — And if a medical bill landed tomorrow, what could you pay without it hurting? ___(bill tomorrow)
- **DO** _only when What's behind it (`why_tags`) includes “Losing coverage”, **or** What's behind it (`why_tags`) includes “No coverage now”_ — Only because they have no cover to lean on. If they have a plan today, skip it.
- **SAY** — The coverage is drafted from a checking or savings account — most carriers don't take cards.
- **ASK** — Do you bank with a credit union or a national bank? [Premium drafts from: Credit union · National bank]

**Buttons**

- [Book the follow-up presentation] → 7.1 Book it (`hs_book`)

---

## 7 · Book It

_Position the presentation and book it with the right people on it._

### 7.1 · Book it  `hs_book`

_Card: reaching it sets `did_discovery`._

- **SAY** — So the next step is a proper walk-through. I'll have real numbers in front of you and we'll go through them together.
- **DO** — You are not closing here. You are booking. Same discipline as any other appointment — two times, who else needs to be on it, and the commitment.

**Buttons**

- [Set the time] → 1.3 Two times (`hs_book_times`)

---

## Blanks

Each `___(label)` in the cards, the card it first appears on, and the profile field it reads and writes.

| Blank | First on | Fills from |
|---|---|---|
| ___(first name) | 1.2 | First name (`first`) |
| ___(your name) | 1.2 | agent Set up: `a_name` |
| ___(time A) | 1.3 | — (typed on the call, not saved) |
| ___(time B) | 1.3 | — (typed on the call, not saved) |
| ___(spouse or partner) | 1.3a | Spouse first name (`sp_name`) |
| ___(phone) | 1.3b | Phone (`phone`) |
| ___(last name) | 2.1 | Last name (`last`) |
| ___(your agency) | 2.1 | agent Set up: `a_agency` |
| ___(your bio) | 2.3 | the agent's bio (Set up), else the default bio |
| ___(they pay) | 2.4a | They pay (`cur_prem`) |
| ___(employer pays) | 2.4a | Employer pays (`cur_emp_prem`) |
| ___(total cost) | 2.4a | Total actual cost (`cur_total`) |
| ___(deductible) | 2.4a | Deductible (`cur_ded`) |
| ___(what was missing) | 2.4a | Comfortable with it, or pieces missing (`cov_gap`) |
| ___(last day of cover) | 2.4a | Last day of cover (`last_day`) |
| ___(current carrier) | 2.4b | Current carrier (`cur_carrier`) |
| ___(plan name) | 2.4b | Plan name (`cur_plan`) |
| ___(out-of-pocket max) | 2.4b | Out-of-pocket max (`cur_oop`) |
| ___(visits a year) | 2.4b | Doctor visits a year (`cur_visits`) |
| ___(copay) | 2.4b | Copay (`cur_copay`) |
| ___(start date) | 2.6 | Wants cover to start (`start_when`) |
| ___(type of work) | 3.2 | What they do (`occupation`) |
| ___(how long) | 3.2 | How long (`occ_years`) |
| ___(zip) | 4.1 | ZIP (`zip`) |
| ___(state) | 4.1 | State (`state`) |
| ___(DOB) | 4.1 | DOB (`dob`) |
| ___(age) | 4.1 | Age (`age`) |
| ___(height) | 4.1 | Height (`height`) |
| ___(weight) | 4.1 | Weight (`weight`) |
| ___(spouse first name) | 4.2 | Spouse first name (`sp_name`) |
| ___(spouse last name) | 4.2 | Spouse last name (`sp_last`) |
| ___(spouse DOB) | 4.2 | Their DOB (`sp_dob`) |
| ___(spouse age) | 4.2 | Age (`sp_age`) |
| ___(spouse height) | 4.2 | Height (`sp_height`) |
| ___(spouse weight) | 4.2 | Weight (`sp_weight`) |
| ___(which GLP-1) | 5.1 | Which one (`glp1_drug`) |
| ___(how long on it) | 5.1 | How long on it (`glp1_since`) |
| ___(what the GLP-1 costs) | 5.1 | What they pay a month (`glp1_cost`) |
| ___(anything else about their health) | 5.1 | Anything else about their health (`health_other`) |
| ___(what for) | 5.2 | What for (`recent_what`) |
| ___(hospital stay) | 5.2 | What for (`stay_what`) |
| ___(planned next year) | 5.3 | Planned in the next 12 months (`planned`) |
| ___(which GLP-1 for the spouse) | 5.4 | Which one (`sp_glp1_drug`) |
| ___(how long the spouse has been on it) | 5.4 | How long on it (`sp_glp1_since`) |
| ___(what the spouse pays for it) | 5.4 | What they pay a month (`sp_glp1_cost`) |
| ___(spouse anything else) | 5.4 | Anything else about their health (`sp_health_notes`) |
| ___(spouse what for) | 5.5 | What for (`sp_recent_what`) |
| ___(spouse stay what) | 5.5 | What for (`sp_stay_what`) |
| ___(your income) | 6.1 | Income this year (`income_this`) |
| ___(your retirement age) | 6.1 | Target retirement age (`i_retire`) |
| ___(approximate savings) | 6.1 | Liquid savings (`i_liquid`) |
| ___(life insurance now) | 6.1 | Life insurance now (incl. through work) (`life_now`) |
| ___(bill tomorrow) | 6.2 | Could pay tomorrow without stress (`bill_tomorrow`) |

