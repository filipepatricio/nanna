import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/intl_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/today_tab_bar_badge/today_tab_bar_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum MainTab { today, explore, saved }

extension MainTabExtension on MainTab {
  Widget icon(BuildContext context) {
    switch (this) {
      case MainTab.today:
        return TodayTabBarBadge(child: _TabBarIcon(AppVectorGraphics.today, title(context), isActive: false));
      case MainTab.explore:
        return _TabBarIcon(AppVectorGraphics.explore, title(context), isActive: false);
      case MainTab.saved:
        return _TabBarIcon(AppVectorGraphics.bookmarkOutline, title(context), isActive: false);
    }
  }

  Widget activeIcon(BuildContext context) {
    switch (this) {
      case MainTab.today:
        return TodayTabBarBadge(child: _TabBarIcon(AppVectorGraphics.today, title(context)));
      case MainTab.explore:
        return _TabBarIcon(AppVectorGraphics.explore, title(context));
      case MainTab.saved:
        return _TabBarIcon(AppVectorGraphics.bookmarkOutline, title(context));
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case MainTab.today:
        return context.l10n.main_todayTab;
      case MainTab.explore:
        return context.l10n.main_exploreTab;
      case MainTab.saved:
        return context.l10n.main_savedTab;
    }
  }

  static MainTab fromIndex(int index) => MainTab.values[index];
}

class _TabBarIcon extends HookWidget {
  const _TabBarIcon(
    this.iconName,
    this.title, {
    this.isActive = true,
  });
  final String iconName;
  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: AppDimens.xxs),
      child: InformedSvg(
        iconName,
        color: isActive ? AppColors.of(context).iconPrimary : AppColors.of(context).iconSecondary,
      ),
    );
  }
}
