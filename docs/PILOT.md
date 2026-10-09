# Pilot readiness (Phase 7) — honest status, updated as gates close

## Launch gates (all must be satisfied before real patient data)
- [ ] consent — explicit in-app consent recorded
- [ ] residency — data residency documented (on-device first)
- [ ] breach — breach notification flow defined
- [ ] deletion — account + data deletion wipes local stores (verified)
- [ ] threshold — recall-first threshold locked from sweep (**needs founder**)
- [ ] metrics — single audited truth, motor-stratified (**needs founder**)
- [ ] disclaimer — detection-aid disclaimer in-app + store listing

## Known issues (do not ship pilot with these open)
1. Headline metrics unreproduced: claimed 63.2%/79%/0.78 AND 47.7%/22.2% —
   latest eval shows 36.8%/82.4%/0.49% on 37,398 windows (87 positives).
   Audit + stratification pending.
2. Threshold untuned: default 0.5 in `app/lib/model/config.dart` is neutral,
   NOT recall-first. Low-threshold sweep (0.05–0.30) pending.
3. On-device inference unvalidated: TFLite binary present, <100ms check
   needs a mobile run (select_tf_ops).
4. Battery benchmark unrun: 8hr background + <5%/hr claim unverified.
5. Netlify demo is access-controlled (401); public links are GitHub Pages.

## Field test protocol (5–10 pairs, when gates close)
1. Pair patient + caregiver, record consent, install pilot build.
2. Phone-on-body briefing (pocket/waist pouch; nighttime plan).
3. 2-week run: every detection labeled true/false/cancelled in
   `FieldTelemetry`; weekly review of precision + cancel rate.
4. Go/no-go: field precision reviewed against disclosed baseline,
   zero unresolved safety events.
