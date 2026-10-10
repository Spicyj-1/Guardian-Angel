# Consent, breach & deletion (NDPR gates — consent/breach/deletion)

## Consent (in-app copy v1, also `safety/consent.dart`)
> Guardian Angel detects seizures WITH MOVEMENT using your phone's motion
> sensors on-device. It is a detection aid, NOT a medical device or a
> replacement for supervision. Non-motor seizures will not trigger alerts.
> Your data stays on this phone unless you sign in and choose sync. You can
> withdraw and delete everything anytime.

Monitoring starts only after Accept. Revoke anytime in Account → deletes
the record and stops monitoring. Gate closes when records persist in Drift
(post-codegen) — UI + record model ship now.

## Breach flow
1. Discover → freeze sync within 24h, assess scope (on-device vs synced).
2. Notify affected users directly (push + SMS) within 72h with what/impact/fix.
3. Log incident in repo; report to NDPR Commission where required.
4. Post-mortem → code/config fix before re-enabling sync.

## Deletion
Account screen → Delete everything: wipes Drift tables, secure storage,
caches, then signs out. Server mirror (when backend lands) deleted via
account-deletion call before local wipe. Verified by re-open: empty state.
