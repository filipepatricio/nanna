import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_animation.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum _CalendarItemType {
  normal,
  selected,
  disable,
  current,
}

class DailyBriefCalendar extends StatelessWidget {
  const DailyBriefCalendar({
    required this.isVisible,
    required this.isFloating,
    required this.currentBriefDate,
    required this.pastDaysBriefs,
    required this.cubit,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final bool isVisible;
  final bool isFloating;
  final DateTime currentBriefDate;
  final List<PastDaysBrief> pastDaysBriefs;
  final DailyBriefPageCubit cubit;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isFloating ? 3 : 0,
      color: AppColors.background,
      child: AnimatedContainer(
        height: isVisible ? AppDimens.calendarAppBar : AppDimens.zero,
        width: double.infinity,
        duration: const Duration(milliseconds: AppAnimation.calendarBriefDuration),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(
          AppDimens.l,
          AppDimens.sl,
          AppDimens.l,
          AppDimens.zero,
        ),
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: const Duration(milliseconds: AppAnimation.calendarBriefDuration),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: pastDaysBriefs
                .map(
                  (e) => _CalendarItem(
                    pastDaysBrief: e,
                    currentBriefDate: currentBriefDate,
                    onTap: () {
                      scrollController.animateTo(
                        0,
                        duration: const Duration(
                          milliseconds: AppAnimation.scrollBriefDuration,
                        ),
                        curve: Curves.easeInOut,
                      );

                      cubit.selectBrief(e.brief);
                    },
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
    required this.pastDaysBrief,
    required this.currentBriefDate,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final PastDaysBrief pastDaysBrief;
  final DateTime currentBriefDate;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final type = useState(_CalendarItemType.normal);

    BoxDecoration? itemDecoration() {
      if (type.value == _CalendarItemType.selected) {
        return BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(AppDimens.s),
        );
      }

      if (type.value == _CalendarItemType.current) {
        return BoxDecoration(
          border: Border.all(color: AppColors.charcoal),
          borderRadius: BorderRadius.circular(AppDimens.s),
        );
      }

      return null;
    }

    useEffect(
      () {
        if (pastDaysBrief.brief?.date == currentBriefDate) {
          type.value = _CalendarItemType.selected;
          return;
        }

        if (pastDaysBrief.date.weekday == clock.now().weekday) {
          type.value = _CalendarItemType.current;
          return;
        }

        if (pastDaysBrief.brief == null) {
          type.value = _CalendarItemType.disable;
          return;
        }

        type.value = _CalendarItemType.normal;
      },
      [currentBriefDate, pastDaysBrief],
    );

    return GestureDetector(
      onTap: type.value == _CalendarItemType.disable ? null : onTap,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          AppColors.textGrey,
          type.value == _CalendarItemType.disable ? BlendMode.srcIn : BlendMode.dst,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: AppDimens.l - AppDimens.xxs,
                width: AppDimens.xl,
                child: Center(
                  child: Text(
                    DateFormat(DateFormat.ABBR_WEEKDAY).format(pastDaysBrief.date),
                    style: AppTypography.subH2Medium,
                  ),
                ),
              ),
              Container(
                width: AppDimens.xl,
                height: AppDimens.xl,
                alignment: Alignment.center,
                decoration: itemDecoration(),
                child: Text(
                  DateFormat(DateFormat.DAY).format(pastDaysBrief.date),
                  style: type.value == _CalendarItemType.selected
                      ? AppTypography.h4Bold.copyWith(
                          color: AppColors.white,
                          height: AppDimens.zero,
                        )
                      : AppTypography.h4Medium.copyWith(
                          height: AppDimens.zero,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
