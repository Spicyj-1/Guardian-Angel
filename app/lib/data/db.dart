// Guardian Angel — local Drift schema (Phase 2).
// App + database run locally (PRD Appendix A). No backend.
import 'package:drift/drift.dart';

part 'db.g.dart';

class Seizures extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationSeconds => integer()();
  TextColumn get severity => text().withDefault(const Constant('unknown'))();
  RealColumn get confidence => real().withDefault(const Constant(0))();
  BoolColumn get cancelled => boolean().withDefault(const Constant(false))();
  // Local-vs-synced indicator (PRD §8): true until a future backend sync.
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
}

class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dose => text().withDefault(const Constant(''))();
  DateTimeColumn get dueAt => dateTime()();
  BoolColumn get taken => boolean().withDefault(const Constant(false))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
}

class Caregivers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get contact => text()(); // phone or email
  TextColumn get inviteStatus => text().withDefault(const Constant('pending'))();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
}

/// Codegen target: `flutter pub run build_runner build` in CI commits
/// `db.g.dart` back (see .github/workflows/codegen.yml). Drift-backed
/// repositories replace the in-memory ones with zero UI changes.
@DriftDatabase(tables: [Seizures, Medications, Caregivers])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  @override
  int get schemaVersion => 1;

  Future<List<Seizure>> recentSeizures(int limit) =>
      (select(seizures)
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
            ..limit(limit))
          .get();

  Future<int> addSeizure(SeizuresCompanion e) => into(seizures).insert(e);

  Future<List<Medication>> dueMeds() => select(medications).get();

  Future<int> setTaken(int id, bool taken) =>
      (update(medications)..where((t) => t.id.equals(id)))
          .write(MedicationsCompanion(taken: Value(taken)));
}
