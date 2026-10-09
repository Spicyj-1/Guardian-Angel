# Firebase backend setup (founder steps — code side is ready)

The app ships with `LocalAccountStub` (works now) + `FirebaseAccountService`
(swaps in here). To activate cloud auth:

1. **Create project:** console.firebase.google.com → Add project
   (name e.g. `guardian-angel`). **Region — DECIDED 10 Oct 2026:
   `europe-west1` (Belgium)** (EU adequacy + latency to Nigeria; no African
   region for Auth/Firestore). Firestore Standard edition. Analytics skipped
   (NDPR minimal collection). Recorded in PRD Appendix C; residency gate satisfied.
2. **Enable Email/Password:** Build → Authentication → Sign-in method → enable.
3. **Register apps:** add Android (package name) + iOS (bundle ID) + Web.
   Download `google-services.json` / `GoogleService-Info.plist` and run
   `flutterfire configure` for `lib/firebase_options.dart`.
   **These files stay on your machines only — all three are gitignored.**
4. **Swap the service:** in `lib/main.dart`, replace `LocalAccountStub()`
   with `FirebaseAccountService()` after `Firebase.initializeApp(...)`.
5. **Roles:** patient/caregiver travels as a custom claim set by a backend
   function (Phase 6+). Until then role is client-side UI gating only —
   never trust it for data access rules.

## NDPR region — what it means
"Region" = the country/continent where Firebase physically stores patient
data. NDPR (Nigeria Data Protection Regulation) requires Nigerians' personal
and health data to be protected, and cross-border hosting must be documented
and adequate. Practical impact for us:
- Firestore/Functions region is chosen once at creation (e.g. `europe-west`
  for EU adequacy + low latency to Nigeria; there is no Africa region for
  all services — verify at setup time and record the pick).
- Keep the server copy minimal (mirror of on-device Drift truth) so the
  residency footprint stays small and the deletion gate stays easy.
- Record the chosen region in PRD Appendix C (residency gate) before any
  real patient data flows. No region recorded = pilot stays blocked.
