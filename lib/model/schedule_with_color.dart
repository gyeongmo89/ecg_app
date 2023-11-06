import 'package:ecg_app/database/drift_database.dart';

// 스케쥴을 담아 놓기 위해서 클래스를 생성함.
class ScheduleWithColor {
  final Schedule schedule;
  final CategoryColor categoryColor;

  ScheduleWithColor({
    required this.schedule,
    required this.categoryColor,
});

}