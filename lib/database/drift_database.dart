// drift_database.dart: 데이터베이스 구성 및 쿼리문 작성

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ecg_app/model/schedule.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
part 'drift_database.g.dart'; // part 는 private 값까지 불러올 수 있어서 part로 함(import 보다 더 범위가 넓음)

@DriftDatabase(
  tables: [
    Schedules, // 테이블명
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // 스키마 버전 표시

  Future<Schedule> getScheduleById(int id) => // ID 값을 기준으로 가져옴
  (select(schedules)
    ..where((tbl) => tbl.id.equals(id)))
      .getSingle(); //ID 하나만 가져옴

  // INSERT 쿼리
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(
          data); // insert를 하면 자동으로 PRIMARY KEY(ID)를 return 받을음(int)

  // Color join 하는부분은 현재 불필요하여 주석처리함
  // Future<int> createCategoryColor(CategoryColorsCompanion data) =>
  //     into(categoryColors).insert(data);
  //
  // // COLOR JOIN 쿼리
  // Future<List<CategoryColor>> getCategoryColors() =>
  //     select(categoryColors).get(); // color을 다 갖고옴

  // DELETE 쿼리
  Future<int> removeSchedule(int id) =>
      (delete(schedules)
        ..where((tbl) => tbl.id.equals(id))).go(); // 모두 다 삭제

  // UPDATE 쿼리
  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)
        ..where((tbl) => tbl.id.equals(id))).write(data);

  // 모든 일정 데이터를 가져오는 메서드
  Stream<List<Schedule>> getAllSchedules() => select(schedules).watch();

  // date, symptom, activity, content 필드만 가져오는 쿼리
  Future<List<Map<String, dynamic>>> getDateSymptomActivityContent() =>
      select(schedules).map((row) => {
        'date': row.date,
        'startTime' : row.startTime,
        'endTime' : row.endTime,
        'symptom': row.symptom,
        'activity': row.activity,
        'content': row.content,
      }).get();

  Stream<List<Schedule>> watchSchedules(DateTime date){
    // final query = select(schedules);
    //     query.where((tbl) => tbl.date.equals(date));
    // return query.watch();  //3줄이 아래 한줄과 같은 뜻 이므로 주석처리
    return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }
}

LazyDatabase _openConnection() {
  // 데이터베이스 생성
  return LazyDatabase(() async {
    final dbFolder =
        await getApplicationDocumentsDirectory(); // 모바일에 데이터 저장할 위치
    final file =
        File(p.join(dbFolder.path, "db.sqlite")); // html이 아닌 io에서 불러와야 함.
    return NativeDatabase(file);
  });
}
