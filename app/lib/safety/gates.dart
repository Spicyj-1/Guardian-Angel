// Guardian Angel — Phase 7: NDPR + safety gates (pure Dart).
// Ethics Appendix C, principle 4 (privacy) + 5 (safety), made executable:
// consent must exist before monitoring, deletion must wipe everything,
// and the pilot cannot start with open blockers.

enum GateStatus { open, satisfied }

class NdprGate {
  final String id;
  final String requirement;
  GateStatus status;
  NdprGate({
    required this.id,
    required this.requirement,
    this.status = GateStatus.open,
  });
}

/// Pilot launch gates. ALL must be satisfied before real patient data.
List<NdprGate> pilotGates() => [
      NdprGate(
          id: 'consent',
          requirement: 'Explicit in-app consent recorded (patient + caregiver).'),
      NdprGate(
          id: 'residency',
          requirement:
              'Data residency decided and documented (decided 09 Oct 2026: europe-west — EU adequacy; no African region for these services).',
          status: GateStatus.satisfied),
      NdprGate(
          id: 'breach',
          requirement: 'Breach notification flow defined (who is told, how fast).'),
      NdprGate(
          id: 'deletion',
          requirement: 'Account + data deletion wipes local stores (verified).'),
      NdprGate(
          id: 'threshold',
          requirement: 'Recall-first threshold locked from sweep (Phase 1 sign-off).'),
      NdprGate(
          id: 'metrics',
          requirement:
              'Headline metrics single audited truth (motor-stratified). Conflict resolved.'),
      NdprGate(
          id: 'disclaimer',
          requirement:
              'Detection-aid disclaimer in-app + store listing (not a medical device).'),
    ];

bool pilotReady(List<NdprGate> gates) =>
    gates.every((g) => g.status == GateStatus.satisfied);

List<String> openBlockers(List<NdprGate> gates) => gates
    .where((g) => g.status == GateStatus.open)
    .map((g) => '${g.id}: ${g.requirement}')
    .toList();
