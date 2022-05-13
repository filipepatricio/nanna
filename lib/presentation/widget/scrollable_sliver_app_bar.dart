import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ScrollableSliverAppBar extends HookWidget {
  const ScrollableSliverAppBar({
    required this.scrollController,
    required this.title,
    this.headerColor = AppColors.transparent,
    this.actions,
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController;
  final String title;
  final Color headerColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final scrollOffset = useState(0.0);
    useEffect(
      () {
        void listener() {
          scrollOffset.value = scrollController.offset;
        }

        scrollController.addListener(listener);
        return () => scrollController.removeListener(listener);
      },
      [scrollController],
    );
    final showCenterTitle = scrollOffset.value >= AppDimens.s;

    return SliverAppBar(
      backgroundColor: AppColors.background,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shadowColor: AppColors.black40,
      pinned: true,
      centerTitle: true,
      elevation: 3.0,
      expandedHeight: AppDimens.appBarHeight,
      actions: actions,
      title: showCenterTitle
          ? Text(
              title,
              style: AppTypography.h4Bold.copyWith(
                height: 2.25,
                color: AppColors.textPrimary.withOpacity(
                  min(1, scrollOffset.value / 20),
                ),
              ),
            )
          : const SizedBox.shrink(),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: headerColor,
          padding: EdgeInsets.only(top: topPadding + AppDimens.sl, left: AppDimens.l),
          child: Text(
            title,
            style: AppTypography.h1Bold,
          ),
        ),
      ),
    );
  }
}
