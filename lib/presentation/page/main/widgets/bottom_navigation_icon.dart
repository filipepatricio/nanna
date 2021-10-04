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
        return _BottomNavigationIcon(AppVectorGraphics.today, _title(), isActive: false);
      case MainTabs.explore:
        return _BottomNavigationIcon(AppVectorGraphics.explore, _title(), isActive: false);
      case MainTabs.my_reads:
        return _BottomNavigationIcon(AppVectorGraphics.myReads, _title(), isActive: false);
    }
  }

  Widget _activeIcon() {
    switch (this) {
      case MainTabs.today:
        return _BottomNavigationIcon(AppVectorGraphics.todaySelected, _title());
      case MainTabs.explore:
        return _BottomNavigationIcon(AppVectorGraphics.exploreSelected, _title());
      case MainTabs.my_reads:
        return _BottomNavigationIcon(AppVectorGraphics.myReadsSelected, _title());
    }
  }

  String _title() {
    switch (this) {
      case MainTabs.today:
        return LocaleKeys.main_todayTab.tr();
      case MainTabs.explore:
        return LocaleKeys.main_exploreTab.tr();
      case MainTabs.my_reads:
        return LocaleKeys.main_myReadsTab.tr();
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      child: SvgPicture.asset(iconName),
    );
  }
}
