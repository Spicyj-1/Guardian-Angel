// Guardian Angel — Phase 5: persistence abstraction (pure Dart).
// InMemory ships now (shell + web CI). Drift implementation plugs in after
// `flutter pub run build_runner build` generates code from lib/data/db.dart.
import 'dart:collection';

class SeizureEvent {
  final DateTime at;
  final int durationSeconds;
  final String severity;
  final double confidence;
  final bool cancelled;
  SeizureEvent({
    required this.at,
    required this.durationSeconds,
    this.severity = 'unknown',
    this.confidence = 0,
    this.cancelled = false,
  });
}

class MedDose {
  final String name;
  final String dose;
  final DateTime dueAt;
  bool taken;
  MedDose({
    required this.name,
    required this.dose,
    required this.dueAt,
    this.taken = false,
  });
}

abstract class SeizureLog {
  void add(SeizureEvent e);
  List<SeizureEvent> recent({int limit = 50});
}

abstract class MedsStore {
  void markTaken(String name, DateTime dueAt);
  bool taken(String name, DateTime dueAt);
  List<MedDose> today();
  /// Evenings (date-only) with a taken dose. Source of truth for streaks.
  Set<DateTime> takenEvenings();
}

class InMemorySeizureLog implements SeizureLog {
  final List<SeizureEvent> _items = [];
  @override
  void add(SeizureEvent e) => _items.add(e);
  @override
  List<SeizureEvent> recent({int limit = 50}) =>
      UnmodifiableListView(_items.reversed.take(limit).toList());
}

class InMemoryMedsStore implements MedsStore {
  final List<MedDose> _doses = [
    MedDose(name: 'Carbamazepine', dose: '200mg', dueAt: _todayAt(8)),
    MedDose(name: 'Carbamazepine', dose: '200mg', dueAt: _todayAt(20)),
  ];
  final Set<DateTime> _evenings = {};
  static DateTime _todayAt(int hour) {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, hour);
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  void markTaken(String name, DateTime dueAt) {
    for (final d in _doses) {
      if (d.name == name && d.dueAt == dueAt) d.taken = true;
    }
    if (dueAt.hour == 20) _evenings.add(_day(dueAt));
  }

  @override
  bool taken(String name, DateTime dueAt) =>
      _doses.any((d) => d.name == name && d.dueAt == dueAt && d.taken);

  @override
  List<MedDose> today() => UnmodifiableListView(_doses);

  @override
  Set<DateTime> takenEvenings() => Set.unmodifiable(_evenings);
}
