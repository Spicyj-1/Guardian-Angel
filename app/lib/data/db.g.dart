// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $SeizuresTable extends Seizures with TableInfo<$SeizuresTable, Seizure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeizuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unknown'));
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cancelledMeta =
      const VerificationMeta('cancelled');
  @override
  late final GeneratedColumn<bool> cancelled = GeneratedColumn<bool>(
      'cancelled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cancelled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pendingSyncMeta =
      const VerificationMeta('pendingSync');
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
      'pending_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pending_sync" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startedAt,
        durationSeconds,
        severity,
        confidence,
        cancelled,
        pendingSync
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seizures';
  @override
  VerificationContext validateIntegrity(Insertable<Seizure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('cancelled')) {
      context.handle(_cancelledMeta,
          cancelled.isAcceptableOrUnknown(data['cancelled']!, _cancelledMeta));
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
          _pendingSyncMeta,
          pendingSync.isAcceptableOrUnknown(
              data['pending_sync']!, _pendingSyncMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Seizure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Seizure(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      cancelled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cancelled'])!,
      pendingSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pending_sync'])!,
    );
  }

  @override
  $SeizuresTable createAlias(String alias) {
    return $SeizuresTable(attachedDatabase, alias);
  }
}

class Seizure extends DataClass implements Insertable<Seizure> {
  final int id;
  final DateTime startedAt;
  final int durationSeconds;
  final String severity;
  final double confidence;
  final bool cancelled;
  final bool pendingSync;
  const Seizure(
      {required this.id,
      required this.startedAt,
      required this.durationSeconds,
      required this.severity,
      required this.confidence,
      required this.cancelled,
      required this.pendingSync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['severity'] = Variable<String>(severity);
    map['confidence'] = Variable<double>(confidence);
    map['cancelled'] = Variable<bool>(cancelled);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  SeizuresCompanion toCompanion(bool nullToAbsent) {
    return SeizuresCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      durationSeconds: Value(durationSeconds),
      severity: Value(severity),
      confidence: Value(confidence),
      cancelled: Value(cancelled),
      pendingSync: Value(pendingSync),
    );
  }

  factory Seizure.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Seizure(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      severity: serializer.fromJson<String>(json['severity']),
      confidence: serializer.fromJson<double>(json['confidence']),
      cancelled: serializer.fromJson<bool>(json['cancelled']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'severity': serializer.toJson<String>(severity),
      'confidence': serializer.toJson<double>(confidence),
      'cancelled': serializer.toJson<bool>(cancelled),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  Seizure copyWith(
          {int? id,
          DateTime? startedAt,
          int? durationSeconds,
          String? severity,
          double? confidence,
          bool? cancelled,
          bool? pendingSync}) =>
      Seizure(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        severity: severity ?? this.severity,
        confidence: confidence ?? this.confidence,
        cancelled: cancelled ?? this.cancelled,
        pendingSync: pendingSync ?? this.pendingSync,
      );
  Seizure copyWithCompanion(SeizuresCompanion data) {
    return Seizure(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      severity: data.severity.present ? data.severity.value : this.severity,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      cancelled: data.cancelled.present ? data.cancelled.value : this.cancelled,
      pendingSync:
          data.pendingSync.present ? data.pendingSync.value : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Seizure(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('severity: $severity, ')
          ..write('confidence: $confidence, ')
          ..write('cancelled: $cancelled, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, durationSeconds, severity,
      confidence, cancelled, pendingSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Seizure &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.severity == this.severity &&
          other.confidence == this.confidence &&
          other.cancelled == this.cancelled &&
          other.pendingSync == this.pendingSync);
}

class SeizuresCompanion extends UpdateCompanion<Seizure> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<int> durationSeconds;
  final Value<String> severity;
  final Value<double> confidence;
  final Value<bool> cancelled;
  final Value<bool> pendingSync;
  const SeizuresCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.severity = const Value.absent(),
    this.confidence = const Value.absent(),
    this.cancelled = const Value.absent(),
    this.pendingSync = const Value.absent(),
  });
  SeizuresCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    required int durationSeconds,
    this.severity = const Value.absent(),
    this.confidence = const Value.absent(),
    this.cancelled = const Value.absent(),
    this.pendingSync = const Value.absent(),
  })  : startedAt = Value(startedAt),
        durationSeconds = Value(durationSeconds);
  static Insertable<Seizure> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<int>? durationSeconds,
    Expression<String>? severity,
    Expression<double>? confidence,
    Expression<bool>? cancelled,
    Expression<bool>? pendingSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (severity != null) 'severity': severity,
      if (confidence != null) 'confidence': confidence,
      if (cancelled != null) 'cancelled': cancelled,
      if (pendingSync != null) 'pending_sync': pendingSync,
    });
  }

  SeizuresCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? startedAt,
      Value<int>? durationSeconds,
      Value<String>? severity,
      Value<double>? confidence,
      Value<bool>? cancelled,
      Value<bool>? pendingSync}) {
    return SeizuresCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
      cancelled: cancelled ?? this.cancelled,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (cancelled.present) {
      map['cancelled'] = Variable<bool>(cancelled.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeizuresCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('severity: $severity, ')
          ..write('confidence: $confidence, ')
          ..write('cancelled: $cancelled, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
      'dose', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _takenMeta = const VerificationMeta('taken');
  @override
  late final GeneratedColumn<bool> taken = GeneratedColumn<bool>(
      'taken', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("taken" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _streakDaysMeta =
      const VerificationMeta('streakDays');
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
      'streak_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('self'));
  static const VerificationMeta _verifiedMeta =
      const VerificationMeta('verified');
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
      'verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pendingSyncMeta =
      const VerificationMeta('pendingSync');
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
      'pending_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pending_sync" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, dose, dueAt, taken, streakDays, source, verified, pendingSync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<Medication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose']!, _doseMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('taken')) {
      context.handle(
          _takenMeta, taken.isAcceptableOrUnknown(data['taken']!, _takenMeta));
    }
    if (data.containsKey('streak_days')) {
      context.handle(
          _streakDaysMeta,
          streakDays.isAcceptableOrUnknown(
              data['streak_days']!, _streakDaysMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('verified')) {
      context.handle(_verifiedMeta,
          verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta));
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
          _pendingSyncMeta,
          pendingSync.isAcceptableOrUnknown(
              data['pending_sync']!, _pendingSyncMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dose'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      taken: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}taken'])!,
      streakDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_days'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      verified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}verified'])!,
      pendingSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pending_sync'])!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final int id;
  final String name;
  final String dose;
  final DateTime dueAt;
  final bool taken;
  final int streakDays;
  final String source;
  final bool verified;
  final bool pendingSync;
  const Medication(
      {required this.id,
      required this.name,
      required this.dose,
      required this.dueAt,
      required this.taken,
      required this.streakDays,
      required this.source,
      required this.verified,
      required this.pendingSync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['dose'] = Variable<String>(dose);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['taken'] = Variable<bool>(taken);
    map['streak_days'] = Variable<int>(streakDays);
    map['source'] = Variable<String>(source);
    map['verified'] = Variable<bool>(verified);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      dose: Value(dose),
      dueAt: Value(dueAt),
      taken: Value(taken),
      streakDays: Value(streakDays),
      source: Value(source),
      verified: Value(verified),
      pendingSync: Value(pendingSync),
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dose: serializer.fromJson<String>(json['dose']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      taken: serializer.fromJson<bool>(json['taken']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      source: serializer.fromJson<String>(json['source']),
      verified: serializer.fromJson<bool>(json['verified']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dose': serializer.toJson<String>(dose),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'taken': serializer.toJson<bool>(taken),
      'streakDays': serializer.toJson<int>(streakDays),
      'source': serializer.toJson<String>(source),
      'verified': serializer.toJson<bool>(verified),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  Medication copyWith(
          {int? id,
          String? name,
          String? dose,
          DateTime? dueAt,
          bool? taken,
          int? streakDays,
          String? source,
          bool? verified,
          bool? pendingSync}) =>
      Medication(
        id: id ?? this.id,
        name: name ?? this.name,
        dose: dose ?? this.dose,
        dueAt: dueAt ?? this.dueAt,
        taken: taken ?? this.taken,
        streakDays: streakDays ?? this.streakDays,
        source: source ?? this.source,
        verified: verified ?? this.verified,
        pendingSync: pendingSync ?? this.pendingSync,
      );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dose: data.dose.present ? data.dose.value : this.dose,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      taken: data.taken.present ? data.taken.value : this.taken,
      streakDays:
          data.streakDays.present ? data.streakDays.value : this.streakDays,
      source: data.source.present ? data.source.value : this.source,
      verified: data.verified.present ? data.verified.value : this.verified,
      pendingSync:
          data.pendingSync.present ? data.pendingSync.value : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('dueAt: $dueAt, ')
          ..write('taken: $taken, ')
          ..write('streakDays: $streakDays, ')
          ..write('source: $source, ')
          ..write('verified: $verified, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, dose, dueAt, taken, streakDays, source, verified, pendingSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.dose == this.dose &&
          other.dueAt == this.dueAt &&
          other.taken == this.taken &&
          other.streakDays == this.streakDays &&
          other.source == this.source &&
          other.verified == this.verified &&
          other.pendingSync == this.pendingSync);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> dose;
  final Value<DateTime> dueAt;
  final Value<bool> taken;
  final Value<int> streakDays;
  final Value<String> source;
  final Value<bool> verified;
  final Value<bool> pendingSync;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dose = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.taken = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.source = const Value.absent(),
    this.verified = const Value.absent(),
    this.pendingSync = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.dose = const Value.absent(),
    required DateTime dueAt,
    this.taken = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.source = const Value.absent(),
    this.verified = const Value.absent(),
    this.pendingSync = const Value.absent(),
  })  : name = Value(name),
        dueAt = Value(dueAt);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dose,
    Expression<DateTime>? dueAt,
    Expression<bool>? taken,
    Expression<int>? streakDays,
    Expression<String>? source,
    Expression<bool>? verified,
    Expression<bool>? pendingSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dose != null) 'dose': dose,
      if (dueAt != null) 'due_at': dueAt,
      if (taken != null) 'taken': taken,
      if (streakDays != null) 'streak_days': streakDays,
      if (source != null) 'source': source,
      if (verified != null) 'verified': verified,
      if (pendingSync != null) 'pending_sync': pendingSync,
    });
  }

  MedicationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? dose,
      Value<DateTime>? dueAt,
      Value<bool>? taken,
      Value<int>? streakDays,
      Value<String>? source,
      Value<bool>? verified,
      Value<bool>? pendingSync}) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      dueAt: dueAt ?? this.dueAt,
      taken: taken ?? this.taken,
      streakDays: streakDays ?? this.streakDays,
      source: source ?? this.source,
      verified: verified ?? this.verified,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (taken.present) {
      map['taken'] = Variable<bool>(taken.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('dueAt: $dueAt, ')
          ..write('taken: $taken, ')
          ..write('streakDays: $streakDays, ')
          ..write('source: $source, ')
          ..write('verified: $verified, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }
}

class $CaregiversTable extends Caregivers
    with TableInfo<$CaregiversTable, Caregiver> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaregiversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contactMeta =
      const VerificationMeta('contact');
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
      'contact', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inviteStatusMeta =
      const VerificationMeta('inviteStatus');
  @override
  late final GeneratedColumn<String> inviteStatus = GeneratedColumn<String>(
      'invite_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _pendingSyncMeta =
      const VerificationMeta('pendingSync');
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
      'pending_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pending_sync" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, contact, inviteStatus, pendingSync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caregivers';
  @override
  VerificationContext validateIntegrity(Insertable<Caregiver> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(_contactMeta,
          contact.isAcceptableOrUnknown(data['contact']!, _contactMeta));
    } else if (isInserting) {
      context.missing(_contactMeta);
    }
    if (data.containsKey('invite_status')) {
      context.handle(
          _inviteStatusMeta,
          inviteStatus.isAcceptableOrUnknown(
              data['invite_status']!, _inviteStatusMeta));
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
          _pendingSyncMeta,
          pendingSync.isAcceptableOrUnknown(
              data['pending_sync']!, _pendingSyncMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Caregiver map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Caregiver(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      contact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact'])!,
      inviteStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invite_status'])!,
      pendingSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pending_sync'])!,
    );
  }

  @override
  $CaregiversTable createAlias(String alias) {
    return $CaregiversTable(attachedDatabase, alias);
  }
}

class Caregiver extends DataClass implements Insertable<Caregiver> {
  final int id;
  final String name;
  final String contact;
  final String inviteStatus;
  final bool pendingSync;
  const Caregiver(
      {required this.id,
      required this.name,
      required this.contact,
      required this.inviteStatus,
      required this.pendingSync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['contact'] = Variable<String>(contact);
    map['invite_status'] = Variable<String>(inviteStatus);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  CaregiversCompanion toCompanion(bool nullToAbsent) {
    return CaregiversCompanion(
      id: Value(id),
      name: Value(name),
      contact: Value(contact),
      inviteStatus: Value(inviteStatus),
      pendingSync: Value(pendingSync),
    );
  }

  factory Caregiver.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Caregiver(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contact: serializer.fromJson<String>(json['contact']),
      inviteStatus: serializer.fromJson<String>(json['inviteStatus']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'contact': serializer.toJson<String>(contact),
      'inviteStatus': serializer.toJson<String>(inviteStatus),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  Caregiver copyWith(
          {int? id,
          String? name,
          String? contact,
          String? inviteStatus,
          bool? pendingSync}) =>
      Caregiver(
        id: id ?? this.id,
        name: name ?? this.name,
        contact: contact ?? this.contact,
        inviteStatus: inviteStatus ?? this.inviteStatus,
        pendingSync: pendingSync ?? this.pendingSync,
      );
  Caregiver copyWithCompanion(CaregiversCompanion data) {
    return Caregiver(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contact: data.contact.present ? data.contact.value : this.contact,
      inviteStatus: data.inviteStatus.present
          ? data.inviteStatus.value
          : this.inviteStatus,
      pendingSync:
          data.pendingSync.present ? data.pendingSync.value : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Caregiver(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('inviteStatus: $inviteStatus, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, contact, inviteStatus, pendingSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Caregiver &&
          other.id == this.id &&
          other.name == this.name &&
          other.contact == this.contact &&
          other.inviteStatus == this.inviteStatus &&
          other.pendingSync == this.pendingSync);
}

class CaregiversCompanion extends UpdateCompanion<Caregiver> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> contact;
  final Value<String> inviteStatus;
  final Value<bool> pendingSync;
  const CaregiversCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contact = const Value.absent(),
    this.inviteStatus = const Value.absent(),
    this.pendingSync = const Value.absent(),
  });
  CaregiversCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String contact,
    this.inviteStatus = const Value.absent(),
    this.pendingSync = const Value.absent(),
  })  : name = Value(name),
        contact = Value(contact);
  static Insertable<Caregiver> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? contact,
    Expression<String>? inviteStatus,
    Expression<bool>? pendingSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contact != null) 'contact': contact,
      if (inviteStatus != null) 'invite_status': inviteStatus,
      if (pendingSync != null) 'pending_sync': pendingSync,
    });
  }

  CaregiversCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? contact,
      Value<String>? inviteStatus,
      Value<bool>? pendingSync}) {
    return CaregiversCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      inviteStatus: inviteStatus ?? this.inviteStatus,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (inviteStatus.present) {
      map['invite_status'] = Variable<String>(inviteStatus.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaregiversCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('inviteStatus: $inviteStatus, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SeizuresTable seizures = $SeizuresTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $CaregiversTable caregivers = $CaregiversTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [seizures, medications, caregivers];
}

typedef $$SeizuresTableCreateCompanionBuilder = SeizuresCompanion Function({
  Value<int> id,
  required DateTime startedAt,
  required int durationSeconds,
  Value<String> severity,
  Value<double> confidence,
  Value<bool> cancelled,
  Value<bool> pendingSync,
});
typedef $$SeizuresTableUpdateCompanionBuilder = SeizuresCompanion Function({
  Value<int> id,
  Value<DateTime> startedAt,
  Value<int> durationSeconds,
  Value<String> severity,
  Value<double> confidence,
  Value<bool> cancelled,
  Value<bool> pendingSync,
});

class $$SeizuresTableFilterComposer
    extends Composer<_$AppDatabase, $SeizuresTable> {
  $$SeizuresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cancelled => $composableBuilder(
      column: $table.cancelled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnFilters(column));
}

class $$SeizuresTableOrderingComposer
    extends Composer<_$AppDatabase, $SeizuresTable> {
  $$SeizuresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cancelled => $composableBuilder(
      column: $table.cancelled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnOrderings(column));
}

class $$SeizuresTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeizuresTable> {
  $$SeizuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<bool> get cancelled =>
      $composableBuilder(column: $table.cancelled, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => column);
}

class $$SeizuresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SeizuresTable,
    Seizure,
    $$SeizuresTableFilterComposer,
    $$SeizuresTableOrderingComposer,
    $$SeizuresTableAnnotationComposer,
    $$SeizuresTableCreateCompanionBuilder,
    $$SeizuresTableUpdateCompanionBuilder,
    (Seizure, BaseReferences<_$AppDatabase, $SeizuresTable, Seizure>),
    Seizure,
    PrefetchHooks Function()> {
  $$SeizuresTableTableManager(_$AppDatabase db, $SeizuresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeizuresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeizuresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeizuresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<bool> cancelled = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
          }) =>
              SeizuresCompanion(
            id: id,
            startedAt: startedAt,
            durationSeconds: durationSeconds,
            severity: severity,
            confidence: confidence,
            cancelled: cancelled,
            pendingSync: pendingSync,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime startedAt,
            required int durationSeconds,
            Value<String> severity = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<bool> cancelled = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
          }) =>
              SeizuresCompanion.insert(
            id: id,
            startedAt: startedAt,
            durationSeconds: durationSeconds,
            severity: severity,
            confidence: confidence,
            cancelled: cancelled,
            pendingSync: pendingSync,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SeizuresTable, Seizure>(table),
                    BaseReferences<_$AppDatabase, $SeizuresTable, Seizure>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SeizuresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SeizuresTable,
    Seizure,
    $$SeizuresTableFilterComposer,
    $$SeizuresTableOrderingComposer,
    $$SeizuresTableAnnotationComposer,
    $$SeizuresTableCreateCompanionBuilder,
    $$SeizuresTableUpdateCompanionBuilder,
    (Seizure, BaseReferences<_$AppDatabase, $SeizuresTable, Seizure>),
    Seizure,
    PrefetchHooks Function()>;
typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String> dose,
  required DateTime dueAt,
  Value<bool> taken,
  Value<int> streakDays,
  Value<String> source,
  Value<bool> verified,
  Value<bool> pendingSync,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> dose,
  Value<DateTime> dueAt,
  Value<bool> taken,
  Value<int> streakDays,
  Value<String> source,
  Value<bool> verified,
  Value<bool> pendingSync,
});

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get taken => $composableBuilder(
      column: $table.taken, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get verified => $composableBuilder(
      column: $table.verified, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnFilters(column));
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get taken => $composableBuilder(
      column: $table.taken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get verified => $composableBuilder(
      column: $table.verified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnOrderings(column));
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get taken =>
      $composableBuilder(column: $table.taken, builder: (column) => column);

  GeneratedColumn<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => column);
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, BaseReferences<_$AppDatabase, $MedicationsTable, Medication>),
    Medication,
    PrefetchHooks Function()> {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> dose = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<bool> taken = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<bool> verified = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
          }) =>
              MedicationsCompanion(
            id: id,
            name: name,
            dose: dose,
            dueAt: dueAt,
            taken: taken,
            streakDays: streakDays,
            source: source,
            verified: verified,
            pendingSync: pendingSync,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> dose = const Value.absent(),
            required DateTime dueAt,
            Value<bool> taken = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<bool> verified = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            id: id,
            name: name,
            dose: dose,
            dueAt: dueAt,
            taken: taken,
            streakDays: streakDays,
            source: source,
            verified: verified,
            pendingSync: pendingSync,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MedicationsTable, Medication>(table),
                    BaseReferences<_$AppDatabase, $MedicationsTable,
                        Medication>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, BaseReferences<_$AppDatabase, $MedicationsTable, Medication>),
    Medication,
    PrefetchHooks Function()>;
typedef $$CaregiversTableCreateCompanionBuilder = CaregiversCompanion Function({
  Value<int> id,
  required String name,
  required String contact,
  Value<String> inviteStatus,
  Value<bool> pendingSync,
});
typedef $$CaregiversTableUpdateCompanionBuilder = CaregiversCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> contact,
  Value<String> inviteStatus,
  Value<bool> pendingSync,
});

class $$CaregiversTableFilterComposer
    extends Composer<_$AppDatabase, $CaregiversTable> {
  $$CaregiversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inviteStatus => $composableBuilder(
      column: $table.inviteStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnFilters(column));
}

class $$CaregiversTableOrderingComposer
    extends Composer<_$AppDatabase, $CaregiversTable> {
  $$CaregiversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inviteStatus => $composableBuilder(
      column: $table.inviteStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => ColumnOrderings(column));
}

class $$CaregiversTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaregiversTable> {
  $$CaregiversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get inviteStatus => $composableBuilder(
      column: $table.inviteStatus, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
      column: $table.pendingSync, builder: (column) => column);
}

class $$CaregiversTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CaregiversTable,
    Caregiver,
    $$CaregiversTableFilterComposer,
    $$CaregiversTableOrderingComposer,
    $$CaregiversTableAnnotationComposer,
    $$CaregiversTableCreateCompanionBuilder,
    $$CaregiversTableUpdateCompanionBuilder,
    (Caregiver, BaseReferences<_$AppDatabase, $CaregiversTable, Caregiver>),
    Caregiver,
    PrefetchHooks Function()> {
  $$CaregiversTableTableManager(_$AppDatabase db, $CaregiversTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaregiversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaregiversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaregiversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> contact = const Value.absent(),
            Value<String> inviteStatus = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
          }) =>
              CaregiversCompanion(
            id: id,
            name: name,
            contact: contact,
            inviteStatus: inviteStatus,
            pendingSync: pendingSync,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String contact,
            Value<String> inviteStatus = const Value.absent(),
            Value<bool> pendingSync = const Value.absent(),
          }) =>
              CaregiversCompanion.insert(
            id: id,
            name: name,
            contact: contact,
            inviteStatus: inviteStatus,
            pendingSync: pendingSync,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CaregiversTable, Caregiver>(table),
                    BaseReferences<_$AppDatabase, $CaregiversTable, Caregiver>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CaregiversTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CaregiversTable,
    Caregiver,
    $$CaregiversTableFilterComposer,
    $$CaregiversTableOrderingComposer,
    $$CaregiversTableAnnotationComposer,
    $$CaregiversTableCreateCompanionBuilder,
    $$CaregiversTableUpdateCompanionBuilder,
    (Caregiver, BaseReferences<_$AppDatabase, $CaregiversTable, Caregiver>),
    Caregiver,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SeizuresTableTableManager get seizures =>
      $$SeizuresTableTableManager(_db, _db.seizures);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$CaregiversTableTableManager get caregivers =>
      $$CaregiversTableTableManager(_db, _db.caregivers);
}
