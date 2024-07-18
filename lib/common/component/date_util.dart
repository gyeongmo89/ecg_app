// date_util.dart: 날짜 계산 유틸리티
import 'package:intl/intl.dart';

class DateUtils {
  static String calculateFinishDate(String saveStartDate) {
    if (saveStartDate.isEmpty) {
      return '';
    }
    try {
      DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm').parse(saveStartDate);
      DateTime finishDate = parsedDate.add(Duration(days: 7));
      return DateFormat('yyyy-MM-dd HH:mm').format(finishDate);
    } catch (e) {
      return '';
    }
  }
}