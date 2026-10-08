# Guardian Angel app (Phase 2 shell — Flutter)

NOT yet compiled on this machine (no Flutter SDK here). Run on any Flutter machine:

```
cd app
flutter pub get
flutter run
```

What you get: Patient Home (monitoring toggle, simulate → 12s cancel countdown → escalate),
History tab (log behind icon, per PRD Appendix B), clinical v2 theme.
Model + threshold live in `lib/model/config.dart` (250×6, threshold TODO pending sweep).

Phase 3 adds: `tflite_flutter` (select_tf_ops), background service, Drift database class
(`lib/data/db.dart` holds the tables; codegen via `flutter pub run build_runner build`).
