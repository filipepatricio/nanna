import 'package:better_informed_mobile/exports.dart';

class DateHelper {
  const DateHelper._();

  static String shortDate(DateTime dateTime) {
    final formatter = DateFormat(DateFormat.ABBR_MONTH_DAY);
    return formatter.format(dateTime);
  }
}
