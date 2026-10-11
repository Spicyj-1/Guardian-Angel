# Where keys live (safe-keys map — no real secrets in this repo, ever)

## Local machine only (never committed — gitignored)
- `.env` (copy of `.env.example`): Twilio SID/token/phone/webhook,
  Resend key, FCM server key. Read by tooling at your desk only.
- `android/app/google-services.json`, iOS `GoogleService-Info.plist`,
  `lib/firebase_options.dart`: Firebase app identities. Same rule.
- Streamlit-era `secrets.toml` (training repo): same values, same rule.

## CI (GitHub Secrets — repo Settings → Secrets, never in code)
| Secret name | Used by | Step that reads it |
|---|---|---|
| `GOOGLE_SERVICES_JSON` | APK build | writes `android/app/google-services.json` pre-build |
| `TWILIO_ACCOUNT_SID` / `TWILIO_AUTH_TOKEN` | sender wiring | server-side dispatch only |
| `RESEND_API_KEY` | sender wiring | server-side dispatch only |

Rule: code reads `String.fromEnvironment` / `--dart-define` / CI secrets at
build time. If a key ever touches a commit, rotate it immediately and tell
the team. This file + `.env.example` are the only key-shaped things allowed
in git.
