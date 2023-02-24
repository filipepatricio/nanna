import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_day.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_days.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_animation.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DailyBriefCalendar extends StatelessWidget {
  const DailyBriefCalendar({
    required this.isVisible,
    required this.isFloating,
    required this.selectedBriefDate,
    required this.pastDays,
    required this.cubit,
    required this.scrollController,
    this.isInLoadingState = false,
    Key? key,
  }) : super(key: key);

  final bool isVisible;
  final bool isFloating;
  final DateTime selectedBriefDate;
  final BriefPastDays pastDays;
  final DailyBriefPageCubit cubit;
  final ScrollController scrollController;
  final bool isInLoadingState;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isFloating ? 1.0 : 0.0,
      color: AppColors.of(context).backgroundPrimary,
      child: AnimatedContainer(
        height: isVisible ? AppDimens.calendarAppBar : AppDimens.zero,
        width: double.infinity,
        duration: const Duration(milliseconds: AppAnimation.calendarBriefDuration),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pageHorizontalMargin,
          AppDimens.sl,
          AppDimens.pageHorizontalMargin,
          AppDimens.zero,
        ),
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: const Duration(milliseconds: AppAnimation.calendarBriefDuration),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: pastDays.days
                .map(
                  (day) => _CalendarItem(
                    pastDay: day,
                    selectedBriefDate: selectedBriefDate,
                    onTap: () {
                      scrollController.animateTo(
                        0,
                        duration: const Duration(
                          milliseconds: AppAnimation.scrollBriefDuration,
                        ),
                        curve: Curves.easeInOut,
                      );

                      cubit.selectBrief(day.date);
                    },
                    isInLoadingState: isInLoadingState,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _CalendarItem extends HookWidget {
  const _CalendarItem({
    required this.pastDay,
    required this.selectedBriefDate,
    required this.onTap,
    required this.isInLoadingState,
    Key? key,
  }) : super(key: key);

  final BriefPastDay pastDay;
  final DateTime selectedBriefDate;
  final Function() onTap;
  final bool isInLoadingState;

  @override
  Widget build(BuildContext context) {
    final type = useState(_CalendarItemType.normal);

    useEffect(
      () {
        if (pastDay.date.isSameDateAs(selectedBriefDate)) {
          type.value = _CalendarItemType.selected;

          return;
        }

        if (pastDay.date.isSameDateAs(clock.now()) && pastDay.hasBrief) {
          type.value = _CalendarItemType.current;
          return;
        }

        if (!pastDay.hasBrief || isInLoadingState) {
          type.value = _CalendarItemType.disable;
          return;
        }

        type.value = _CalendarItemType.normal;
      },
      [selectedBriefDate, pastDay, isInLoadingState],
    );

    return GestureDetector(
      onTap: type.value == _CalendarItemType.disable ? null : onTap,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: AppDimens.l - AppDimens.xxs,
              width: AppDimens.xl,
              child: Center(
                child: Text(
                  DateFormat(DateFormat.ABBR_WEEKDAY).format(pastDay.date),
                  style: AppTypography.subH2Medium.copyWith(
                    color: type.value.weekdayColor(context),
                  ),
                ),
              ),
            ),
            Container(
              width: AppDimens.xl,
              height: AppDimens.xl,
              alignment: Alignment.center,
              decoration: type.value.itemDecoration(context),
              child: Text(
                DateFormat(DateFormat.DAY).format(pastDay.date),
                style: type.value == _CalendarItemType.selected
                    ? AppTypography.h4Bold.copyWith(
                        height: AppDimens.zero,
                        color: type.value.dayColor(context),
                      )
                    : AppTypography.b2Medium.copyWith(
                        height: AppDimens.zero,
                        color: type.value.dayColor(context),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _CalendarItemType {
  normal,
  selected,
  disable,
  current,
}

extension on _CalendarItemType {
  Color dayColor(BuildContext context) {
    switch (this) {
      case _CalendarItemType.selected:
        return AppColors.of(context).buttonPrimaryText;
      case _CalendarItemType.disable:
        return AppColors.of(context).textTertiary;

      default:
        return AppColors.of(context).textPrimary;
    }
  }

  Color weekdayColor(BuildContext context) {
    switch (this) {
      case _CalendarItemType.disable:
        return AppColors.of(context).textTertiary;
      default:
        return AppColors.of(context).textPrimary;
    }
  }

  BoxDecoration? itemDecoration(BuildContext context) {
    switch (this) {
      case _CalendarItemType.selected:
        return BoxDecoration(
          color: AppColors.of(context).buttonPrimaryBackground,
          borderRadius: BorderRadius.circular(AppDimens.c),
        );
      case _CalendarItemType.current:
        return BoxDecoration(
          border: Border.all(
            color: AppColors.brandAccent,
          ),
          borderRadius: BorderRadius.circular(AppDimens.c),
        );

      default:
        return null;
    }
  }
}
