// 2023-11-15 증상종류, 활동종류 추가

import 'package:drift/drift.dart';

class Schedules extends Table {
  // PRIMARY KEY
  IntColumn get id =>
      integer().autoIncrement()(); // 함수를 한번더실행 해야됨(인티저) 그래야 에러 없어짐

   // 날짜
  DateTimeColumn get date => dateTime()();

  // 시작시간
  IntColumn get startTime => integer()();

  // 종료시간
  IntColumn get endTime => integer()();

  // 증상종류
  TextColumn get symptom => text()();

  // 활동종류
  TextColumn get activity => text()();

  // 기타설명
  TextColumn get content => text()();

  // // Category Color Table ID
  // IntColumn get colorID => integer()();

  // 생성날짜
  DateTimeColumn get createAt => dateTime().clientDefault(
        () => DateTime.now(), // 생성날짜 자동으로 입력 되도록 함.
      )();
}
