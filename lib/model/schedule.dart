// schedule.dart: 테이블과 컬럼을 정의

import 'package:drift/drift.dart';

class Schedules extends Table {
  // PRIMARY KEY
  IntColumn get id =>
      integer().autoIncrement()(); // 함수를 한번 더 실행 해야됨(integer) 그래야 에러 없음

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

  // 생성날짜
  DateTimeColumn get createAt => dateTime().clientDefault(
        () => DateTime.now(), // 생성 날짜 자동으로 입력
      )();
}
