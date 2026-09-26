# Product Requirements Document

## Project Guardian Angel — Native Mobile App

Team: Promivine (Divine Ande, Luke Promise) Document status: Draft v1.0 Prepared: September 2026  
---

## 1\. Overview

Project Guardian Angel is the first explainable, fully offline AI digital twin for detecting, managing, and helping people survive epileptic seizures. It currently exists as a Streamlit web dashboard; this document defines the requirements for its evolution into a native mobile application, which is required to unlock real-time background monitoring, push alerting, and offline-first operation — none of which a browser-based dashboard can deliver.

## 2\. Problem Statement

An estimated 140,000 people die from epilepsy-related causes globally each year, frequently because seizures occur without warning and go unnoticed until it is too late. Existing monitoring solutions are often costly, require specialized wearables, or depend on constant internet connectivity — excluding rural and lower-income communities, particularly across Nigeria and much of Africa, from access to life-saving early-warning tools.

## 3\. Goals

| Goal | Description |
| :---- | :---- |
| Real-time detection | Detect seizures using motion sensors already present in a standard smartphone |
| Fast, reliable response | Get the right person alerted, with guidance, as fast as possible |
| Offline-first | Function fully without internet connectivity — detection and core app alike |
| Equal utility for both sides | Serve patients and caregivers as equal, first-class users |
| Data respect | Handle sensitive health data responsibly and in line with NDPR |

## 4\. Users & Personas

* Patient — the individual living with epilepsy, wearing/carrying the monitoring phone.  
* Caregiver — family member, friend, or guardian responsible for responding to alerts. May or may not own a smartphone.  
* Both are equal users of the app, each with their own dashboard.

## 5\. Functional Requirements

### 5.1 Seizure Detection (Core Engine)

* Runs continuously in the background, automatically, with no manual start/stop required.  
* Uses phone accelerometer \+ gyroscope data, processed through a 1D-MobileNet \+ LSTM model, distinguishing seizure activity from normal movement (walking, jogging, etc.).  
* Operates fully offline — no internet dependency for detection itself.  
* Model is trained on the SeizeIT2 clinical dataset (20 patients, 23,333 processed data windows), using the accelerometer/gyroscope channels for real-time detection — not the EEG channels also present in the dataset, which is why the current app detects rather than predicts. Current performance is 47.7% sensitivity / 22.2% precision after class-imbalance correction, disclosed transparently as a known area for iteration.

### 5.2 Emergency Alert Flow

1. On detection, the patient is shown a cancel / "I'm okay" button with a visible countdown timer (e.g. "Alerting in 12s") to prevent false-alarm fatigue while preserving the safety net.  
2. If not cancelled, an alert is sent to the first caregiver on the patient's list.  
3. If unacknowledged within a defined window, the system retries the same caregiver, then auto-escalates to the next caregiver on the list, continuing down the list as needed.  
4. Caregiver list length is unlimited — patients can add as many caregivers as they choose.  
5. If every caregiver has been exhausted with no response, the app surfaces emergency services / local hospital hotline info as a last resort (African hospital emergency lines \+ global emergency numbers, carried over from the existing Streamlit implementation).  
6. Alerts are delivered across three channels simultaneously: push notification (fastest), SMS, and email — ensuring delivery regardless of which channel a caregiver actually checks.  
7. Each alert includes location data — live GPS where permission is granted, falling back to a pre-set address from the patient's profile settings if unavailable.  
8. Caregiver's alert screen includes first-aid guidance (what to do, step by step) alongside the alert itself, plus response tracking.

### 5.3 Monitoring Reliability

* If background monitoring stops unexpectedly (app killed, dead battery, revoked permissions), both the patient and all caregivers are notified, including a timestamp of when monitoring last stopped — even while the phone remains on.

### 5.4 Post-Seizure Logging

* Seizures are auto-logged (duration, time, severity) with no manual entry required.

### 5.5 Medication Reminders & Tracking

* Built-in reminders and tracking for the patient's medication schedule, encouraging daily app engagement beyond emergencies.

### 5.6 Caregiver Access & Permissions

* Caregivers can only be added to a patient's circle with the patient's explicit permission/invite.  
* Caregivers have their own dashboard, but see nothing about any patient until they've been added.

### 5.7 Voice Check-In

* Caregivers without a smartphone can call a dedicated number to check a patient's current status/record by voice — carried over from the existing Streamlit implementation, serving both rural and urban caregivers.

### 5.8 Onboarding

* Kept simple and fast — no mandatory calibration step; the model already generalizes and improves over time.  
* An optional visual "how it works" walkthrough is available for users who want it.

### 5.9 Patient Dashboard

Displays, together on one view:

* Recent activity (latest seizures, recent check-ins)  
* Trends over time (seizure frequency, patterns)  
* Medication adherence streaks and simple insights

## 6\. Non-Functional Requirements

| Requirement | Detail |
| :---- | :---- |
| Offline-first | The entire core app — detection, dashboard, logs, medication tracker — must function with zero internet connectivity, not detection alone |
| Data protection | Built with NDPR (Nigeria Data Protection Regulation) compliance in mind from the outset, given the sensitivity of stored health data |
| Reliability | Monitoring-lapse detection must be near-immediate and notify both parties |
| Accessibility | Voice check-in ensures caregivers without smartphones are not excluded |
| Battery/resource efficiency | Background monitoring must be lightweight enough for always-on use without excessive battery drain (inherits from the existing lightweight 1D-MobileNet architecture, \~69K parameters) |

## 7\. Out of Scope (for this version)

* Mandatory per-user calibration/training period during onboarding  
* Wearable/EEG-ECG integration (identified as a future roadmap item, not this build)  
* Doctor-facing exportable reports (medication tracking was chosen over this for now)

## 8\. Known Risks / Open Areas

* Current model precision (22.2%) may produce a meaningful false-positive rate; the cancel/countdown flow is the primary mitigation, but this should be monitored post-launch.  
* Sync behavior between offline-stored data and multi-caregiver dashboards needs a clear indicator so users understand what's local vs. synced.  
* NDPR compliance requirements should be reviewed formally (e.g. data residency, consent flows, breach notification) before handling real patient data at scale.

## 9\. Future Roadmap (Not in Current Scope)

* Predictive detection. The SeizeIT2 dataset already includes EEG data alongside the motion data used for the current model — but the deployed app currently only detects seizures as they happen, using phone accelerometer/gyroscope data. Moving to true prediction (a warning before a seizure starts) requires a wearable device to capture live EEG/ECG signals in the real world — the model side is not the blocker; the missing hardware is.  
* Pilot deployment across partner clinics, pending funding.

---

## Appendix A — Implementation Decisions Note (26 Sept 2026)

Decided with founder, recorded to allow future review/change:

- **Framework: Flutter + Dart (locked).** Why: single codebase for Android/iOS, good background-service + offline support, matches offline-first goal. Rejected: React Native.
- **Database: Drift over SQLite (chosen).** Why: type-safe Dart, reactive `watch()` for dashboard trends/streaks, managed migrations. Rejected: sqflite (raw SQL, manual migrations, no reactivity). Runs locally on-device for now.
- **Authentication: local-only.** Via `local_auth` (PIN/biometric) + `flutter_secure_storage`. Why: offline-first, no server dependency, NDPR-friendly. No cloud auth for now.
- **File storage: local filesystem** via `path_provider` (app documents directory). Models, logs, exports stay on-device for now.
- **App + database run locally for now — no backend / no cloud DB.**
- **Model: user-provided TFLite 0.89MB.** Use existing conversion unless Phase 1 validation fails. Confirm input shape, window, threshold in Phase 1.
- **Design v2 (26 Sept 2026): clinical light theme + fl_chart.** Teal #0E9F8A + navy #0B2A3A on #F2F7F6, Inter, red reserved for alerts. Charts via fl_chart (offline, lightweight, Drift-friendly). Rejected: heavy chart SDKs.

This note may be revised — keep rationale when changing.

---

## Appendix B — Design Review Note v2 (26 Sept 2026, vs design-preview.html)

Reviewed `design-preview.html` v2 (4 phones: Onboarding, Patient Home + chart, Countdown, Caregiver Alert) against PRD §5:

- **Accepted:** clinical light theme #F2F7F6 + navy #0B2A3A + teal #0E9F8A, Inter 15px/20–28px, red reserved for alerts; fl_chart for trends (offline, Drift-friendly).
- **Match:** Onboarding → §5.8 (no calibration, how-it-works, offline, NDPR, patient+caregiver equals). Patient Home → §5.9 (12-week frequency chart + peak highlight + insight, adherence streak). Countdown 12s + I'm-Okay → §5.2 steps 1/6/7 (cancel, 3-channel note, GPS + fallback address). Caregiver Alert → §5.2 step 8 (first-aid steps, Acknowledge/Call, location).
- **Gaps in v2 preview (kept in scope, to re-add in v3):** §5.2 escalation chain + emergency-numbers fallback + response tracking detail; §5.3 monitoring-stopped alert; §5.4 auto-log view; §5.5 meds schedule screen (only streak shown); §5.6 caregiver empty/invite + QR; §5.7 voice check-in number. v1 preview had these — do not drop.
- **Decision:** v2 theme + charts locked; v3 must restore missing screens above with same theme before Flutter build.
- **UX change (founder request):** full event log hidden behind History 🕘 icon — main screen shows only last-event summary + count. Applied to prototype; carries to Flutter History tab.

---

*This PRD reflects decisions made through direct product discussion with the founding team and should be treated as a living document, updated as the build progresses.*

