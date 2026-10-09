// Guardian Angel — Phase 7: field telemetry (pure Dart).
// Answers the open metric conflict with real-world labels: every detection
// ends as TRUE (real seizure), FALSE (false alarm), or CANCELLED (patient
// okay within 12s). Cancelled counts as a caught false positive — the
// cancel flow working as designed (ethics: transparency).
enum DetectionOutcome { truePositive, falsePositive, cancelled }

class DetectionRecord {
  final DateTime at;
  final double probability;
  final DetectionOutcome outcome;
  DetectionRecord({
    required this.at,
    required this.probability,
    required this.outcome,
  });
}

class FieldTelemetry {
  final List<DetectionRecord> _records = [];
  void record(DetectionRecord r) => _records.add(r);
  int get total => _records.length;

  int _count(DetectionOutcome o) =>
      _records.where((r) => r.outcome == o).length;

  /// Field precision: true alarms over all uncancelled alarms.
  double get fieldPrecision {
    final tp = _count(DetectionOutcome.truePositive);
    final fp = _count(DetectionOutcome.falsePositive);
    if (tp + fp == 0) return double.nan;
    return tp / (tp + fp);
  }

  /// Cancel rate: share of detections the patient stopped in time.
  /// High cancel + low false-alarm harm = countdown doing its job.
  double get cancelRate {
    if (_records.isEmpty) return double.nan;
    return _count(DetectionOutcome.cancelled) / _records.length;
  }

  String report() {
    if (_records.isEmpty) return 'No field detections recorded yet.';
    final p = fieldPrecision;
    final c = cancelRate;
    return 'n=${_records.length} '
        'TP=${_count(DetectionOutcome.truePositive)} '
        'FP=${_count(DetectionOutcome.falsePositive)} '
        'cancelled=${_count(DetectionOutcome.cancelled)} '
        'field-precision=${p.isNaN ? 'n/a' : '${(p * 100).toStringAsFixed(1)}%'} '
        'cancel-rate=${c.isNaN ? 'n/a' : '${(c * 100).toStringAsFixed(1)}%'}';
  }
}
