// private 값들은 불러올 수 없다.
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ecg_app/model/category_color.dart';
import 'package:ecg_app/model/schedule.dart';
import 'package:ecg_app/model/schedule_with_color.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// private 값까지 불러올 수 있다.)(import 보다 더 범위가 넓음)
part 'drift_database.g.dart'; // g는 generated (자동으로 생성되었다는 말)
// 현재파일의 이름.g.dart

@DriftDatabase(
  tables: [
    Schedules, // 테이블명
    CategoryColors, // 테이블명
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<Schedule> getScheduleById(int id) =>  // ID 값을 기준으로 가져온다.
  (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle(); //getSingle(하나만 가져온다는 뜻.)

  // createSchedule(SchedulesCompanion data) => into(schedules).insert(data);  // schedules 테이블에 데이터를 넣어 준다.
  Future<int> createSchedule(SchedulesCompanion data) => into(schedules).insert(
      data); // insert를 하면 자동으로 PRIMARY KEY(ID)를 return 받을 수 있다. int 를 리턴 받을 수 있다.

  // INSERT 쿼리
  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  // COLOR JOIN 쿼리
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get(); // color을 다 갖고옴.

  // DELETE 쿼리
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go(); // 모두 다 삭제됨.

  // UPDATE 쿼리
  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  // 모든 일정 데이터를 가져오는 메서드
  Future<List<Schedule>> getAllSchedules() => select(schedules).get();


  // 색깔은 고정되어있어서 Future로 받을 수 있지만 내용은 아니다 그래서 Stream으로 함
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    final query = select(schedules).join([
      // join 할때는 equalsExp, 테이블에서는 equals
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorID))
      // schedules 와 categoryColors 와 join을 하는데, categoryColors.id 가 scheules.colorID와 같은 것을 join 해주겠다.
    ]); // 3줄이 원래는 정석
    query.where(schedules.date.equals(date)); // 테이블에 date와 관련된 데이터만 갖고옴
    query.orderBy(
      [
        // asc -> ascending 오름차순
        // desc -> descending 내림차순
        OrderingTerm.asc(schedules.startTime),
      ],
    );
    
    
    return query.watch().map(
          (rows) => rows.map(
            (row) => ScheduleWithColor(
              schedule: row.readTable(schedules),
              categoryColor: row.readTable(categoryColors),
            ),
          ).toList(),
        ); // 아래 한줄과 같음

    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();  // 업데이트 되었을떄 지속적으로 없데이트 된 값을 받을 수 있음.
  }

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1; // 버전업그레이드, 디폴트는 1부터시작
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
