import 'package:easy_localization/easy_localization.dart';

const _locale = 'en';

class DateFormatUtil {
  const DateFormatUtil._();

  static String formatShortMonthNameDay(DateTime dateTime) {
    final format = DateFormat('MMM d', _locale);
    return format.format(dateTime);
  }

  static String formatFullMonthNameDayYear(DateTime dateTime) {
    final format = DateFormat('MMMM d, yyyy', _locale);
    return format.format(dateTime);
  }
}
