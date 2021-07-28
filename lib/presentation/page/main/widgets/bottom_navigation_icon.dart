import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

enum MainTabs { today, explore, my_reads }

extension Attributes on MainTabs {
  Widget get icon => _icon();

  Widget get activeIcon => _activeIcon();

  String get title => _title();

  Widget _icon() {
    switch (this) {
      case MainTabs.today:
        return _BottomNavigationIcon(AppVectorGraphics.today_icon, _title(), isActive: false);
      case MainTabs.explore:
        return _BottomNavigationIcon(AppVectorGraphics.explore_icon, _title(), isActive: false);
      case MainTabs.my_reads:
        return _BottomNavigationIcon(AppVectorGraphics.my_reads_icon, _title(), isActive: false);
    }
  }

  Widget _activeIcon() {
    switch (this) {
      case MainTabs.today:
        return _BottomNavigationIcon(AppVectorGraphics.today_selected_icon, _title());
      case MainTabs.explore:
        return _BottomNavigationIcon(AppVectorGraphics.explore_selected_icon, _title());
      case MainTabs.my_reads:
        return _BottomNavigationIcon(AppVectorGraphics.my_reads_selected_icon, _title());
    }
  }

  String _title() {
    switch (this) {
      case MainTabs.today:
        return LocaleKeys.main_today_tab.tr();
      case MainTabs.explore:
        return LocaleKeys.main_explore_tab.tr();
      case MainTabs.my_reads:
        return LocaleKeys.main_my_reads_tab.tr();
    }
  }
}

class _BottomNavigationIcon extends HookWidget {
  final String iconName;
  final String title;
  final bool isActive;

  const _BottomNavigationIcon(
    this.iconName,
    this.title, {
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(iconName),
        const SizedBox(height: AppDimens.s),
        Text(
          title,
          style: AppTypography.primaryTextJakarta.copyWith(
            fontSize: AppDimens.naviBarFontSize,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
