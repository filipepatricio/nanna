import 'package:better_informed_mobile/exports.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
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

  static String currentBriefDate(AppLocalizations l10n, DateTime briefDate) {
    final now = clock.now();
    final daysDifference = daysBetween(briefDate, now);

    if (daysDifference == 0) {
      return l10n.dailyBrief_title_today;
    } else if (daysDifference == 1) {
      return l10n.dailyBrief_title_yesterday;
    }

    return DateFormat('EEEE d').format(briefDate) + getDayOfMonthSuffix(l10n, briefDate);
  }

  static String getDayOfMonthSuffix(AppLocalizations l10n, DateTime dateTime) {
    if (dateTime.day >= 11 && dateTime.day <= 13) {
      return l10n.dailyBrief_title_dateTh;
    }

    switch (dateTime.day % 10) {
      case 1:
        return l10n.dailyBrief_title_dateSt;
      case 2:
        return l10n.dailyBrief_title_dateNd;
      case 3:
        return l10n.dailyBrief_title_dateRd;
      default:
        return l10n.dailyBrief_title_dateTh;
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDateAs(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }
}
