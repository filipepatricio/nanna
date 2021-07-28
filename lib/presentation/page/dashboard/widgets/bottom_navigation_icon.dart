import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

enum DashboardTabs { today, explore, my_reads }

extension Attributes on DashboardTabs {
  Widget get icon => _icon();

  Widget get activeIcon => _activeIcon();

  String get title => _title();

  Widget _icon() {
    switch (this) {
      case DashboardTabs.today:
        return _BottomNavigationIcon(AppVectorGraphics.today_icon, _title(), isActive: false);
      case DashboardTabs.explore:
        return _BottomNavigationIcon(AppVectorGraphics.explore_icon, _title(), isActive: false);
      case DashboardTabs.my_reads:
        return _BottomNavigationIcon(AppVectorGraphics.my_reads_icon, _title(), isActive: false);
      default:
        return _BottomNavigationIcon(AppVectorGraphics.today_icon, _title(), isActive: false);
    }
  }

  Widget _activeIcon() {
    switch (this) {
      case DashboardTabs.today:
        return _BottomNavigationIcon(AppVectorGraphics.today_selected_icon, _title());
      case DashboardTabs.explore:
        return _BottomNavigationIcon(AppVectorGraphics.explore_selected_icon, _title());
      case DashboardTabs.my_reads:
        return _BottomNavigationIcon(AppVectorGraphics.my_reads_selected_icon, _title());
      default:
        return _BottomNavigationIcon(AppVectorGraphics.today_selected_icon, _title());
    }
  }

  String _title() {
    switch (this) {
      case DashboardTabs.today:
        return LocaleKeys.dashboard_today_tab.tr();
      case DashboardTabs.explore:
        return LocaleKeys.dashboard_explore_tab.tr();
      case DashboardTabs.my_reads:
        return LocaleKeys.dashboard_my_reads_tab.tr();
      default:
        return LocaleKeys.dashboard_today_tab.tr();
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
