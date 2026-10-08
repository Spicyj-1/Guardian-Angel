// Guardian Angel — local Drift schema (Phase 2).
// App + database run locally (PRD Appendix A). No backend.
import 'package:drift/drift.dart';

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
