// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, Schedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
      'end_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _symptomMeta =
      const VerificationMeta('symptom');
  @override
  late final GeneratedColumn<String> symptom = GeneratedColumn<String>(
      'symptom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activityMeta =
      const VerificationMeta('activity');
  @override
  late final GeneratedColumn<String> activity = GeneratedColumn<String>(
      'activity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  // static const VerificationMeta _colorIDMeta =
  //     const VerificationMeta('colorID');
  // @override
  // late final GeneratedColumn<int> colorID = GeneratedColumn<int>(
  //     'color_i_d', aliasedName, false,
  //     type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        startTime,
        endTime,
        symptom,
        activity,
        content,
        // colorID,
        createAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules';
  @override
  VerificationContext validateIntegrity(Insertable<Schedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('symptom')) {
      context.handle(_symptomMeta,
          symptom.isAcceptableOrUnknown(data['symptom']!, _symptomMeta));
    } else if (isInserting) {
      context.missing(_symptomMeta);
    }
    if (data.containsKey('activity')) {
      context.handle(_activityMeta,
          activity.isAcceptableOrUnknown(data['activity']!, _activityMeta));
    } else if (isInserting) {
      context.missing(_activityMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    // if (data.containsKey('color_i_d')) {
    //   context.handle(_colorIDMeta,
    //       colorID.isAcceptableOrUnknown(data['color_i_d']!, _colorIDMeta));
    // } else if (isInserting) {
    //   context.missing(_colorIDMeta);
    // }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Schedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Schedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time'])!,
      symptom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptom'])!,
      activity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      // colorID: attachedDatabase.typeMapping
      //     .read(DriftSqlType.int, data['${effectivePrefix}color_i_d'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }
}

class Schedule extends DataClass implements Insertable<Schedule> {
  final int id;
  final DateTime date;
  final int startTime;
  final int endTime;
  final String symptom;
  final String activity;
  final String content;
  // final int colorID;
  final DateTime createAt;
  const Schedule(
      {required this.id,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.symptom,
      required this.activity,
      required this.content,
      // required this.colorID,
      required this.createAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['start_time'] = Variable<int>(startTime);
    map['end_time'] = Variable<int>(endTime);
    map['symptom'] = Variable<String>(symptom);
    map['activity'] = Variable<String>(activity);
    map['content'] = Variable<String>(content);
    // map['color_i_d'] = Variable<int>(colorID);
    map['create_at'] = Variable<DateTime>(createAt);
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      date: Value(date),
      startTime: Value(startTime),
      endTime: Value(endTime),
      symptom: Value(symptom),
      activity: Value(activity),
      content: Value(content),
      // colorID: Value(colorID),
      createAt: Value(createAt),
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Schedule(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int>(json['endTime']),
      symptom: serializer.fromJson<String>(json['symptom']),
      activity: serializer.fromJson<String>(json['activity']),
      content: serializer.fromJson<String>(json['content']),
      // colorID: serializer.fromJson<int>(json['colorID']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int>(endTime),
      'symptom': serializer.toJson<String>(symptom),
      'activity': serializer.toJson<String>(activity),
      'content': serializer.toJson<String>(content),
      // 'colorID': serializer.toJson<int>(colorID),
      'createAt': serializer.toJson<DateTime>(createAt),
    };
  }

  Schedule copyWith(
          {int? id,
          DateTime? date,
          int? startTime,
          int? endTime,
          String? symptom,
          String? activity,
          String? content,
          // int? colorID,
          DateTime? createAt}) =>
      Schedule(
        id: id ?? this.id,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        symptom: symptom ?? this.symptom,
        activity: activity ?? this.activity,
        content: content ?? this.content,
        // colorID: colorID ?? this.colorID,
        createAt: createAt ?? this.createAt,
      );
  @override
  String toString() {
    return (StringBuffer('Schedule(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('symptom: $symptom, ')
          ..write('activity: $activity, ')
          ..write('content: $content, ')
          // ..write('colorID: $colorID, ')
          ..write('createAt: $createAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, startTime, endTime, symptom,
      // activity, content, colorID, createAt);
      activity, content,  createAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Schedule &&
          other.id == this.id &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.symptom == this.symptom &&
          other.activity == this.activity &&
          other.content == this.content &&
          // other.colorID == this.colorID &&
          other.createAt == this.createAt);
}

class SchedulesCompanion extends UpdateCompanion<Schedule> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<String> symptom;
  final Value<String> activity;
  final Value<String> content;
  // final Value<int> colorID;
  final Value<DateTime> createAt;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.symptom = const Value.absent(),
    this.activity = const Value.absent(),
    this.content = const Value.absent(),
    // this.colorID = const Value.absent(),
    this.createAt = const Value.absent(),
  });
  SchedulesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int startTime,
    required int endTime,
    required String symptom,
    required String activity,
    required String content,
    // required int colorID,
    this.createAt = const Value.absent(),
  })  : date = Value(date),
        startTime = Value(startTime),
        endTime = Value(endTime),
        symptom = Value(symptom),
        activity = Value(activity),
        content = Value(content);
        // colorID = Value(colorID);
  static Insertable<Schedule> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<String>? symptom,
    Expression<String>? activity,
    Expression<String>? content,
    // Expression<int>? colorID,
    Expression<DateTime>? createAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (symptom != null) 'symptom': symptom,
      if (activity != null) 'activity': activity,
      if (content != null) 'content': content,
      // if (colorID != null) 'color_i_d': colorID,
      if (createAt != null) 'create_at': createAt,
    });
  }

  SchedulesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? startTime,
      Value<int>? endTime,
      Value<String>? symptom,
      Value<String>? activity,
      Value<String>? content,
      // Value<int>? colorID,
      Value<DateTime>? createAt}) {
    return SchedulesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      symptom: symptom ?? this.symptom,
      activity: activity ?? this.activity,
      content: content ?? this.content,
      // colorID: colorID ?? this.colorID,
      createAt: createAt ?? this.createAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (symptom.present) {
      map['symptom'] = Variable<String>(symptom.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(activity.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    // if (colorID.present) {
    //   map['color_i_d'] = Variable<int>(colorID.value);
    // }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('symptom: $symptom, ')
          ..write('activity: $activity, ')
          ..write('content: $content, ')
          // ..write('colorID: $colorID, ')
          ..write('createAt: $createAt')
          ..write(')'))
        .toString();
  }
}

// class $CategoryColorsTable extends CategoryColors
//     with TableInfo<$CategoryColorsTable, CategoryColor> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $CategoryColorsTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//       'id', aliasedName, false,
//       hasAutoIncrement: true,
//       type: DriftSqlType.int,
//       requiredDuringInsert: false,
//       defaultConstraints:
//           GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
//   static const VerificationMeta _hexCodeMeta =
//       const VerificationMeta('hexCode');
//   @override
//   late final GeneratedColumn<String> hexCode = GeneratedColumn<String>(
//       'hex_code', aliasedName, false,
//       type: DriftSqlType.string, requiredDuringInsert: true);
//   @override
//   List<GeneratedColumn> get $columns => [id, hexCode];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
  // static const String $name = 'category_colors';
  // @override
  // VerificationContext validateIntegrity(Insertable<CategoryColor> instance,
  //     {bool isInserting = false}) {
  //   final context = VerificationContext();
  //   final data = instance.toColumns(true);
  //   if (data.containsKey('id')) {
  //     context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
  //   }
  //   if (data.containsKey('hex_code')) {
  //     context.handle(_hexCodeMeta,
  //         hexCode.isAcceptableOrUnknown(data['hex_code']!, _hexCodeMeta));
  //   } else if (isInserting) {
  //     context.missing(_hexCodeMeta);
  //   }
  //   return context;
  // }
//
//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   CategoryColor map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return CategoryColor(
//       id: attachedDatabase.typeMapping
//           .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
//       hexCode: attachedDatabase.typeMapping
//           .read(DriftSqlType.string, data['${effectivePrefix}hex_code'])!,
//     );
//   }
//
//   @override
//   $CategoryColorsTable createAlias(String alias) {
//     return $CategoryColorsTable(attachedDatabase, alias);
//   }
// }

// class CategoryColor extends DataClass implements Insertable<CategoryColor> {
//   final int id;
//   final String hexCode;
//   const CategoryColor({required this.id, required this.hexCode});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['hex_code'] = Variable<String>(hexCode);
//     return map;
//   }

  // CategoryColorsCompanion toCompanion(bool nullToAbsent) {
  //   return CategoryColorsCompanion(
  //     id: Value(id),
  //     hexCode: Value(hexCode),
  //   );
  // }

  // factory CategoryColor.fromJson(Map<String, dynamic> json,
  //     {ValueSerializer? serializer}) {
  //   serializer ??= driftRuntimeOptions.defaultSerializer;
  //   return CategoryColor(
  //     id: serializer.fromJson<int>(json['id']),
  //     hexCode: serializer.fromJson<String>(json['hexCode']),
  //   );
  // }
  // @override
  // Map<String, dynamic> toJson({ValueSerializer? serializer}) {
  //   serializer ??= driftRuntimeOptions.defaultSerializer;
  //   return <String, dynamic>{
  //     'id': serializer.toJson<int>(id),
  //     'hexCode': serializer.toJson<String>(hexCode),
  //   };
  // }

  // CategoryColor copyWith({int? id, String? hexCode}) => CategoryColor(
  //       id: id ?? this.id,
  //       hexCode: hexCode ?? this.hexCode,
  //     );
  // @override
  // String toString() {
  //   return (StringBuffer('CategoryColor(')
  //         ..write('id: $id, ')
  //         ..write('hexCode: $hexCode')
  //         ..write(')'))
  //       .toString();
  // }

  // @override
  // int get hashCode => Object.hash(id, hexCode);
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     (other is CategoryColor &&
  //         other.id == this.id &&
  //         other.hexCode == this.hexCode);
// }

// class CategoryColorsCompanion extends UpdateCompanion<CategoryColor> {
//   final Value<int> id;
//   final Value<String> hexCode;
//   const CategoryColorsCompanion({
//     this.id = const Value.absent(),
//     this.hexCode = const Value.absent(),
//   });
//   CategoryColorsCompanion.insert({
//     this.id = const Value.absent(),
//     required String hexCode,
//   }) : hexCode = Value(hexCode);
//   static Insertable<CategoryColor> custom({
//     Expression<int>? id,
//     Expression<String>? hexCode,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (hexCode != null) 'hex_code': hexCode,
//     });
//   }

  // CategoryColorsCompanion copyWith({Value<int>? id, Value<String>? hexCode}) {
  //   return CategoryColorsCompanion(
  //     id: id ?? this.id,
  //     hexCode: hexCode ?? this.hexCode,
  //   );
  // }

  // @override
  // Map<String, Expression> toColumns(bool nullToAbsent) {
  //   final map = <String, Expression>{};
  //   if (id.present) {
  //     map['id'] = Variable<int>(id.value);
  //   }
  //   if (hexCode.present) {
  //     map['hex_code'] = Variable<String>(hexCode.value);
  //   }
  //   return map;
  // }
  //
  // @override
  // String toString() {
  //   return (StringBuffer('CategoryColorsCompanion(')
  //         ..write('id: $id, ')
  //         ..write('hexCode: $hexCode')
  //         ..write(')'))
  //       .toString();
  // }
// }

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  // late final $CategoryColorsTable categoryColors = $CategoryColorsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      // [schedules, categoryColors];
  [schedules];
}
