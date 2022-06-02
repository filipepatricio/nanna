import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodaysTopicsScrollableAppBar extends HookWidget {
  const TodaysTopicsScrollableAppBar({
    required this.scrollController,
    required this.briefDate,
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController;
  final DateTime briefDate;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final showCenterTitle = useState(false);

    useEffect(
      () {
        void listener() {
          showCenterTitle.value = scrollController.offset >= AppDimens.s;
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
      elevation: 3.0,
      expandedHeight: AppDimens.appBarHeight,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 50),
        opacity: showCenterTitle.value ? 1 : 0,
        child: Text(
          DateFormatUtil.currentBriefDate(briefDate),
          style: AppTypography.h4Bold.copyWith(height: 2.25),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: AppColors.background,
          padding: EdgeInsets.only(top: topPadding + AppDimens.sl, left: AppDimens.l, right: AppDimens.l),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormatUtil.currentBriefDate(briefDate),
                style: AppTypography.todaysTopicsTitle,
              ),
              const Spacer(),
              Text(
                DateFormatUtil.formatFullMonthNameDayYear(briefDate),
                style: AppTypography.b3Medium.copyWith(color: AppColors.textGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
