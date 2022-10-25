import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

enum MainTab { today, explore, profile }

extension MainTabExtension on MainTab {
  Widget get icon => _icon();

  Widget get activeIcon => _activeIcon();

  String get title => _title();

  Widget _icon() {
    switch (this) {
      case MainTab.today:
        return _TabBarIcon(AppVectorGraphics.today, _title(), isActive: false);
      case MainTab.explore:
        return _TabBarIcon(AppVectorGraphics.explore, _title(), isActive: false);
      case MainTab.profile:
        return _TabBarIcon(AppVectorGraphics.profile, _title(), isActive: false);
    }
  }

  Widget _activeIcon() {
    switch (this) {
      case MainTab.today:
        return _TabBarIcon(AppVectorGraphics.today, _title());
      case MainTab.explore:
        return _TabBarIcon(AppVectorGraphics.explore, _title());
      case MainTab.profile:
        return _TabBarIcon(AppVectorGraphics.profile, _title());
    }
  }

  String _title() {
    switch (this) {
      case MainTab.today:
        return LocaleKeys.main_todayTab.tr();
      case MainTab.explore:
        return LocaleKeys.main_exploreTab.tr();
      case MainTab.profile:
        return LocaleKeys.main_profileTab.tr();
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
      padding: const EdgeInsets.only(bottom: AppDimens.s),
      child: SvgPicture.asset(iconName, color: isActive ? AppColors.charcoal : AppColors.neutralGrey),
    );
  }
}
