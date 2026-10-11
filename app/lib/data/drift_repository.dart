// Guardian Angel — Drift-backed repositories (mobile persistence).
// Used by the mobile entrypoint (path_provider + NativeDatabase).
// NOT imported by web builds. In-memory impls remain the web fallback.
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'db.dart' as store;
import 'repository.dart';

Future<store.AppDatabase> openLocalDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/guardian_angel.sqlite');
  return store.AppDatabase(NativeDatabase(file));
}

class DriftSeizureLog implements SeizureLog {
  final store.AppDatabase db;
  DriftSeizureLog(this.db);

  @override
  void add(SeizureEvent e) {
    db.addSeizure(store.SeizuresCompanion(
      startedAt: Value(e.at),
      durationSeconds: Value(e.durationSeconds),
      severity: Value(e.severity),
      confidence: Value(e.confidence),
      cancelled: Value(e.cancelled),
    ));
  }

  @override
  List<SeizureEvent> recent({int limit = 50}) {
    // Synchronous shell over the async store; mobile entrypoint refreshes
    // via FutureBuilder. Kept simple until the mobile main lands.
    throw UnimplementedError(
        'Use recentAsync() on mobile; shell uses InMemorySeizureLog.');
  }

  Future<List<SeizureEvent>> recentAsync({int limit = 50}) async {
    final rows = await db.recentSeizures(limit);
    return rows
        .map((r) => SeizureEvent(
              at: r.startedAt,
              durationSeconds: r.durationSeconds,
              severity: r.severity,
              confidence: r.confidence,
              cancelled: r.cancelled,
            ))
        .toList();
  }
}

class DriftMedsStore implements MedsStore {
  final store.AppDatabase db;
  List<store.Medication> _cache = [];
  DriftMedsStore(this.db);

  Future<void> refresh() async => _cache = await db.dueMeds();

  @override
  Future<void> addDose(MedDose dose) async {
    await db.into(db.medications).insert(store.MedicationsCompanion(
          name: Value(dose.name),
          dose: Value(dose.dose),
          dueAt: Value(dose.dueAt),
          source: Value(dose.source),
          verified: Value(dose.verified),
        ));
    await refresh();
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Future<void> markTaken(String name, DateTime dueAt) async {
    for (final d in _cache) {
      if (d.name == name && d.dueAt == dueAt && !d.taken) {
        await db.setTaken(d.id, true);
      }
    }
    await refresh();
  }

  @override
  bool taken(String name, DateTime dueAt) =>
      _cache.any((d) => d.name == name && d.dueAt == dueAt && d.taken);

  @override
  List<MedDose> today() => _cache
      .map((d) => MedDose(
          name: d.name,
          dose: d.dose,
          dueAt: d.dueAt,
          taken: d.taken,
          source: d.source,
          verified: d.verified))
      .toList();

  @override
  List<MedDose> history() {
    final taken = today().where((d) => d.taken).toList()
      ..sort((a, b) => b.dueAt.compareTo(a.dueAt));
    return taken;
  }

  @override
  Set<DateTime> takenEvenings() => _cache
      .where((d) => d.taken && d.dueAt.hour == 20)
      .map((d) => _day(d.dueAt))
      .toSet();
}
