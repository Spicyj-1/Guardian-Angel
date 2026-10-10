// Guardian Angel — consent record (ethics Appendix C: privacy).
// Recorded before monitoring starts. Persists via Drift once codegen lands;
// until then the record lives in memory and the pilot consent gate stays open.
class ConsentRecord {
  final DateTime at;
  final String scope; // e.g. 'monitoring+alerts'
  final String version; // copy version, e.g. 'consent-v1'
  ConsentRecord({required this.at, required this.scope, required this.version});
}

class ConsentStore {
  ConsentRecord? _record;
  ConsentRecord? get record => _record;
  bool get granted => _record != null;
  void grant(String scope, String version) =>
      _record = ConsentRecord(at: DateTime.now(), scope: scope, version: version);
  void revoke() => _record = null;
}

const String consentCopyV1 = 'Guardian Angel detects seizures WITH MOVEMENT '
    'using your phone\u2019s motion sensors on-device. It is a detection aid, '
    'NOT a medical device or a replacement for supervision. Non-motor seizures '
    'will not trigger alerts. Your data stays on this phone unless you sign in '
    'and choose sync. You can withdraw and delete everything anytime.';
