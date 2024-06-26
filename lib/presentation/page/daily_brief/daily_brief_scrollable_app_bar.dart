import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_days.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_animation.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/no_connection_banner/no_connection_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DailyBriefAppBar extends HookWidget {
  const DailyBriefAppBar({
    required this.scrollController,
    required this.briefDate,
    required this.pastDays,
    required this.cubit,
    required this.showCalendar,
    required this.showAppBarTitle,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  DailyBriefAppBar.disabled({
    required ScrollController scrollController,
    required DailyBriefPageCubit cubit,
  }) : this(
          scrollController: scrollController,
          cubit: cubit,
          briefDate: DateTime.now(),
          pastDays: BriefPastDays.empty(),
          showAppBarTitle: true,
          showCalendar: false,
          enabled: false,
        );

  final ScrollController scrollController;
  final DateTime briefDate;
  final BriefPastDays pastDays;
  final DailyBriefPageCubit cubit;
  final bool showCalendar;
  final bool showAppBarTitle;
  final bool enabled;

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
      pinned: true,
      centerTitle: true,
      elevation: showCalendar ? 0 : 1.0,
      toolbarHeight: kToolbarHeight,
      expandedHeight: AppDimens.appBarHeight,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: AppAnimation.opacityDuration),
        opacity: showAppBarTitle ? 1 : 0,
        child: BriefDate(
          briefDate: briefDate,
          isTitle: true,
          showCalendar: showCalendar,
          showCalendarButton: pastDays.days.isNotEmpty,
          onTap: () => cubit.toggleCalendar(!showCalendar),
        ),
      ),
      flexibleSpace: enabled
          ? FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                color: AppColors.of(context).backgroundPrimary,
                padding: EdgeInsets.only(
                  top: topPadding + AppDimens.sl,
                  left: AppDimens.pageHorizontalMargin,
                  right: AppDimens.pageHorizontalMargin,
                  bottom: context.watch<IsConnected>() ? AppDimens.zero : AppDimens.m,
                ),
                child: AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: AppAnimation.opacityDuration,
                  ),
                  opacity: !showAppBarTitle ? 1 : 0,
                  child: BriefDate(
                    briefDate: briefDate,
                    isTitle: false,
                    showCalendar: showCalendar,
                    showCalendarButton: pastDays.days.isNotEmpty,
                    onTap: () => cubit.toggleCalendar(!showCalendar),
                  ),
                ),
              ),
            )
          : null,
      bottom: context.watch<IsConnected>() ? null : const NoConnectionBanner(),
    );
  }
}

class BriefDate extends StatelessWidget {
  const BriefDate({
    required this.briefDate,
    required this.isTitle,
    required this.showCalendar,
    required this.showCalendarButton,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final DateTime briefDate;
  final bool isTitle;
  final bool showCalendar;
  final bool showCalendarButton;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final shouldUseBottomPadding = !context.watch<IsConnected>() && !isTitle;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: shouldUseBottomPadding ? const EdgeInsets.only(bottom: AppDimens.s) : EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormatUtil.currentBriefDate(context.l10n, briefDate),
              style: isTitle ? AppTypography.h4Medium.copyWith(height: 2) : AppTypography.sansTitleLargeLausanne,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: showCalendarButton
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: AppDimens.s,
                        top: isTitle ? AppDimens.s : AppDimens.zero,
                      ),
                      child: AnimatedRotation(
                        turns: showCalendar ? 0.5 : 1,
                        duration: const Duration(milliseconds: AppAnimation.calendarBriefDuration),
                        child: InformedSvg(
                          AppVectorGraphics.chevronDown,
                          color: Theme.of(context).iconTheme.color,
                          height: isTitle ? AppDimens.m : AppDimens.l,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
