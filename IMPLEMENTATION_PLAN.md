# Guardian Angel — Implementation Plan

Source: `(GUARDIAN ANGEL)-Product Requirements Document.md` Draft v1.0 (Sept 2026)
Team: Promivine (Divine Ande, Luke Promise)
Start state: docs-only, `6e952f2 Initial commit`, `README.md` stub only.

## Phase 0 — Repo foundation (STACK: Flutter, local-only)
Output: Flutter monorepo scaffold + CI + docs in git
- Framework: Flutter + Dart (locked)
- Database: Drift over SQLite — runs locally on-device, no cloud DB for now
- Authentication: local-only — device PIN/biometric via `local_auth` + `flutter_secure_storage`, no server auth for now
- File storage: local filesystem via `path_provider` (app documents directory) — models, logs, exports stay on-device for now
- App + database run locally for now — no backend required
- Layout: `app/`, `model/`, `docs/`, `tests/`
- Packages: `tflite_flutter`, `drift` (+ `sqlite3`), `flutter_local_notifications`, `geolocator`, `firebase_messaging`
- Add lint, unit test runner
- Acceptance: blank app launches from clean clone (`flutter run`)

## Phase 1 — Model packaging (user TFLite 0.89MB)
Ref: PRD 5.1, 6 battery/resource, 8 risks. Baseline 47.7% sens / 22.2% prec.
Output: validated `model/guardianangel.tflite` (user-provided 0.89MB) + validation report
- Use existing user-converted TFLite (0.89MB) — no re-export unless validation fails. Confirm input shape, sampling rate, window size, threshold config
- Reproduce metrics on SeizeIT2 (20 patients, 23,333 windows, accel/gyro only — not EEG)
- Acceptance: on-device inference <100ms/window via `tflite_flutter`, documented FP rate

## Phase 2 — Offline-first shell + onboarding (STORAGE: Drift)
Ref: PRD 5.8, 6 offline-first, 6 data protection
Output: installable app with local DB, no backend required
- Onboarding: no calibration, optional "how it works" walkthrough
- Local storage decision: Drift (chosen) over sqflite — type-safe Dart, reactive `watch()` for dashboard trends/streaks, managed migrations. sqflite rejected: raw SQL, manual migrations, no reactivity.
- Tables: seizures, medications, caregivers + sync-pending flag (PRD 8: local vs synced indicator)
- NDPR basics: consent screen, on-device encryption
- Acceptance: airplane-mode install → onboard → use dashboard

## Phase 3 — Background detection service (real-time)
Ref: PRD 5.1, 5.3
Output: always-on accel+gyro service with on-device inference
- Real-time loop: accel+gyro sampled 25-50Hz → sliding window buffer (e.g. 5s) → TFLite inference on-device, fully offline → score > threshold = seizure → Phase 4 countdown. Distinguish seizure vs walk/jog.
- Platform: ForegroundService (Android) / BackgroundTasks (iOS), auto-restart on reboot
- Monitoring-lapse: watchdog heartbeat every 1-2 min writes `last_active`. Patient gets immediate local notification if service dies while phone is on. Caregiver notify uses last pushed heartbeat via FCM/SMS when online (impossible purely offline) + `last_active` synced on reconnect.
- Acceptance: 8hr background run proves always-on; <5%/hr battery via ~69K-param model + duty-cycling + no network; kill → patient immediate + caregivers with timestamp on next sync/push

## Phase 4 — Emergency alert flow
Ref: PRD 5.2
Output: cancel countdown → escalate → fallback chain
- Patient: "Alerting in 12s" + I'm-okay cancel
- Multi-channel simultaneous: push (FCM) + SMS + email
- Unlimited caregiver list, retry → next escalation; exhausted → emergency/hospital numbers (port from Streamlit)
- GPS live + fallback preset address; first-aid screen + ack tracking
- Acceptance: simulated seizure triggers full chain in <30s, logged

## Phase 5 — Logging + Patient dashboard + Meds
Ref: PRD 5.4, 5.5, 5.9
Output: auto-log + dashboard + reminders
- Seizure table: time/duration/severity, no manual entry
- Dashboard: recent activity, frequency trends, adherence streaks + insights
- Local notifications for meds, streak logic
- Acceptance: offline seizure → log + charts; med reminder fires offline

## Phase 6 — Caregiver + Voice + Reliability
Ref: PRD 5.6, 5.7
Output: invite-only caregiver app + voice IVR
- Caregiver dashboard empty until invite accepted
- Response tracking, sync indicator
- Voice check-in: Twilio/Africa's Talking number reading status (carry over Streamlit)
- Acceptance: non-smartphone call returns status; caregiver sees data only post-invite

## Phase 7 — Hardening for pilot
Ref: PRD 8
Output: test + compliance + pilot build
- False-positive telemetry, battery benchmarks
- NDPR review: residency, breach flow, data deletion
- Field test 5–10 patient-caregiver pairs
- Acceptance: signed pilot APK/IPA + known-issues log

## Out of scope (v1)
- Mandatory per-user calibration
- Wearable/EEG-ECG integration (prediction needs hardware, not model)
- Doctor-facing exportable reports

## Suggested order
Phase 0 + 1 in parallel → 2 → 3 → 4 → 5 → 6 → 7
