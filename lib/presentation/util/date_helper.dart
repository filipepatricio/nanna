import 'package:easy_localization/easy_localization.dart';

class DateHelper {
  const DateHelper._();

  static String shortDate(DateTime dateTime) {
    final formatter = DateFormat(DateFormat.ABBR_MONTH_DAY);
    return formatter.format(dateTime);
  }
}
