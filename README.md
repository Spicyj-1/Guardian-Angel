# Project Guardian Angel — Native Mobile App

> First explainable, fully offline AI digital twin for detecting, managing, and helping people survive epileptic seizures.

**Team:** Promivine (Divine Ande, Luke Promise)
**Status:** Draft v1.0 — September 2026
**Source spec:** `(GUARDIAN ANGEL)-Product Requirements Document.md`
**Previous incarnation:** Streamlit web dashboard → now evolving to native mobile

## Problem

An estimated 140,000 people die from epilepsy-related causes globally each year, often because seizures occur without warning and go unnoticed. Existing solutions are costly, require specialized wearables, or need constant internet — excluding rural and lower-income communities, particularly across Nigeria and Africa.

## Goals

- **Real-time detection** using motion sensors already in a standard smartphone
- **Fast, reliable response** — right person alerted, with guidance, as fast as possible
- **Offline-first** — detection and core app work with zero internet
- **Equal utility** — patients and caregivers as equal, first-class users
- **Data respect** — sensitive health data handled per NDPR (Nigeria Data Protection Regulation)

## Users

- **Patient** — individual living with epilepsy, carrying the monitoring phone
- **Caregiver** — family / friend / guardian who responds to alerts. May not own a smartphone.
- Both have their own dashboard. Caregivers see nothing until added via explicit patient invite/permission.

## Key Features (v1)

### 1. Seizure Detection (Core Engine)
- Continuous background monitoring, automatic — no manual start/stop
- Phone accelerometer + gyroscope → 1D-MobileNet + LSTM (~69K params, lightweight for always-on)
- Fully offline inference
- Trained on SeizeIT2 clinical dataset (20 patients, 23,333 windows, accel/gyro channels — not EEG)
- Current performance (disclosed): **47.7% sensitivity / 22.2% precision** after class-imbalance correction — iteration area
- No mandatory calibration; generalizes + improves over time. Optional "how it works" walkthrough.

### 2. Emergency Alert Flow
1. Detection → patient sees Cancel / "I'm okay" with countdown (e.g. "Alerting in 12s")
2. If not cancelled → alert first caregiver
3. If unacknowledged → retry, then auto-escalate down unlimited-length caregiver list
4. If all exhausted → surface emergency services / local hospital hotlines (African + global numbers)
5. Delivery on 3 channels simultaneously: push (fastest) + SMS + email
6. Includes location: live GPS if permitted, else pre-set address from profile
7. Caregiver alert screen includes step-by-step first-aid guidance + response tracking

### 3. Reliability
- If monitoring stops (app killed, dead battery, revoked permissions), patient + all caregivers notified with last-active timestamp

### 4. Post-Seizure Logging
- Auto-logged (duration, time, severity), no manual entry

### 5. Medication Reminders & Tracking
- Reminders + adherence streaks + insights — drives daily engagement

### 6. Voice Check-In
- Caregivers without smartphones can call a dedicated number to check status by voice

### 7. Patient Dashboard (single view)
- Recent activity (latest seizures, check-ins)
- Trends (frequency, patterns)
- Medication adherence + insights

## Non-Functional Requirements

- **Offline-first:** entire core app (detection, dashboard, logs, meds) works offline
- **NDPR compliance** from outset — needs formal review (residency, consent, breach notification) before scale
- **Battery efficiency:** lightweight model for always-on use
- **Accessibility:** voice path for non-smartphone caregivers

## Out of Scope (v1)

- Mandatory per-user calibration
- Wearable / EEG-ECG integration (future roadmap)
- Doctor-facing exportable reports (meds tracking chosen instead)

## Known Risks

- 22.2% precision → false-positive rate; mitigated by cancel/countdown, monitor post-launch
- Offline ↔ multi-caregiver sync needs clear local-vs-synced indicator

## Future Roadmap

- **Predictive detection:** SeizeIT2 has EEG, but live prediction needs wearable EEG/ECG hardware — model is not the blocker
- Pilot deployment across partner clinics, pending funding

## Repo Layout

```
.
├── (GUARDIAN ANGEL)-Product Requirements Document.md  # Living PRD — source of truth
└── README.md                                          # This file
```

No implementation code yet — this commit is docs-only initial version.

---
*This README is derived from direct product discussion with the founding team. PRD is living document — update as build progresses.*
