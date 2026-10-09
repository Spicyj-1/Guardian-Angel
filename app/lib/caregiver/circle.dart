// Guardian Angel — Phase 6: caregiver circle (pure Dart).
// PRD 5.6: invite-only. A caregiver sees NOTHING until a patient adds them.
// Response tracking (PRD 5.2): ack latency recorded per alert.
class LinkedPatient {
  final String name;
  final String inviteCode;
  final List<Duration> ackLatencies = [];
  LinkedPatient({required this.name, required this.inviteCode});
  double get avgAckSeconds => ackLatencies.isEmpty
      ? 0
      : ackLatencies.map((d) => d.inSeconds).reduce((a, b) => a + b) /
          ackLatencies.length;
}

class CaregiverCircle {
  final List<LinkedPatient> _patients = [];
  List<LinkedPatient> get patients => List.unmodifiable(_patients);
  bool get isEmpty => _patients.isEmpty;

  /// Accept an invite. Codes are issued patient-side (QR/share); here we
  /// validate format only — server verification arrives with the backend.
  /// Returns the linked patient, or null for a malformed code.
  LinkedPatient? acceptInvite(String code, String patientName) {
    final clean = code.trim().toUpperCase();
    if (!RegExp(r'^[A-Z0-9]{4}-[A-Z0-9]{4}$').hasMatch(clean)) return null;
    final p = LinkedPatient(name: patientName, inviteCode: clean);
    _patients.add(p);
    return p;
  }

  void recordAck(LinkedPatient p, Duration latency) =>
      p.ackLatencies.add(latency);
}
