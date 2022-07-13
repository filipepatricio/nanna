import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DailyBriefScrollableAppBar extends HookWidget {
  const DailyBriefScrollableAppBar({
    required this.scrollController,
    required this.briefDate,
    required this.pastDaysBriefs,
    required this.cubit,
    required this.showCalendar,
    required this.showAppBarTitle,
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController;
  final DateTime briefDate;
  final List<PastDaysBrief> pastDaysBriefs;
  final DailyBriefPageCubit cubit;
  final bool showCalendar;
  final bool showAppBarTitle;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    useEffect(
      () {
        void listener() {
          if (scrollController.offset >= AppDimens.s) {
            cubit.toggleAppBarTitle(true);
          } else {
            cubit.toggleAppBarTitle(false);
          }

          if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
            cubit.toggleCalendar(false);
          }
        }

        scrollController.addListener(listener);
        return () => scrollController.removeListener(listener);
      },
      [scrollController],
    );

    return SliverAppBar(
      backgroundColor: AppColors.background,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shadowColor: AppColors.black40,
      pinned: true,
      centerTitle: true,
      elevation: showCalendar ? 0 : 3.0,
      expandedHeight: AppDimens.appBarHeight,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 50),
        opacity: showAppBarTitle ? 1 : 0,
        child: BriefDate(
          briefDate: briefDate,
          isTitle: true,
          showCalendar: showCalendar,
          onTap: () => cubit.toggleCalendar(!showCalendar),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: AppColors.background,
          padding: EdgeInsets.only(
            top: topPadding + AppDimens.sl,
            left: AppDimens.l,
            right: AppDimens.l,
          ),
          child: BriefDate(
            briefDate: briefDate,
            isTitle: false,
            showCalendar: showCalendar,
            onTap: () => cubit.toggleCalendar(!showCalendar),
          ),
        ),
      ),
    );
  }
}

class BriefDate extends StatelessWidget {
  const BriefDate({
    required this.briefDate,
    required this.isTitle,
    required this.showCalendar,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final DateTime briefDate;
  final bool isTitle;
  final bool showCalendar;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormatUtil.currentBriefDate(briefDate),
            style: isTitle ? AppTypography.h4Bold.copyWith(height: 2.25) : AppTypography.dailyBriefTitle,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppDimens.xs,
              top: isTitle ? AppDimens.s : AppDimens.zero,
            ),
            child: AnimatedRotation(
              turns: showCalendar ? 0.25 : 0.75,
              duration: const Duration(milliseconds: 175),
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.black,
                size: isTitle ? AppDimens.m : AppDimens.l,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
