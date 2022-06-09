import 'dart:ui';

import 'package:better_informed_mobile/exports.dart';
import 'package:clock/clock.dart';
import 'package:jiffy/jiffy.dart';

const _locale = 'en';

class DateFormatUtil {
  const DateFormatUtil._();

  static Future<void> setJiffyLocale([Locale? locale]) async {
    await Jiffy.locale(locale?.languageCode ?? _locale);
  }

  static String formatShortMonthNameDay(DateTime dateTime) {
    final format = DateFormat('MMM d, yyyy', _locale);
    return format.format(dateTime);
  }

  static String formatFullMonthNameDayYear(DateTime dateTime) {
    final format = DateFormat('MMMM d, yyyy', _locale);
    return format.format(dateTime);
  }

  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return (toDate.difference(fromDate).inHours / 24).round();
  }

  static int hoursBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inHours.round();
  }

  static String dateTimeFromNow(DateTime dateTime) {
    return Jiffy(dateTime).fromNow();
  }

  static String currentBriefDate(DateTime briefDate) {
    final now = clock.now();
    final daysDifference = daysBetween(briefDate, now);

    if (daysDifference == 0) {
      return LocaleKeys.dailyBrief_title_today.tr();
    } else if (daysDifference == 1) {
      return LocaleKeys.dailyBrief_title_yesterday.tr();
    }

    return DateFormat('EEEE').format(briefDate);
  }
}
