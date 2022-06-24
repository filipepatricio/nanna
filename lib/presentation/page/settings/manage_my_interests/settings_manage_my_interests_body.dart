import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../exports.dart';
import '../../../style/app_dimens.dart';
import '../../../style/typography.dart';
import '../../../widget/physics/platform_scroll_physics.dart';
import '../../../widget/snackbar/snackbar_parent_view.dart';

class SettingsManageMyInterestsBody extends HookWidget {
  final List<CategoryPreference> categoryPreferences;
  final SnackbarController snackbarController;
  final SettingsManageMyInterestsCubit cubit;

  const SettingsManageMyInterestsBody({
    required this.categoryPreferences,
    required this.snackbarController,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: getPlatformScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(AppDimens.l),
                  child: Text(
                    LocaleKeys.settings_manageMyInterests.tr(),
                    style: AppTypography.h4Bold.copyWith(height: 1),
                  ),
                ),
                ...categoryPreferences
                    .map(
                      (data) => _CategoryItem(
                        categoryPreference: data,
                        snackbarController: snackbarController,
                        cubit: cubit,
                        onSwitch: (value) {
                          cubit.updatePreferredCategories(
                            categoryPreferences.map((e) => e == data ? e.copyWith(isPreferred: value) : e).toList(),
                          );
                        },
                      ),
                    )
                    .expand((element) => [element, const Divider()]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryPreference categoryPreference;
  final SnackbarController snackbarController;
  final SettingsManageMyInterestsCubit cubit;
  final Function(bool) onSwitch;

  const _CategoryItem({
    required this.categoryPreference,
    required this.snackbarController,
    required this.cubit,
    required this.onSwitch,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Row(
        children: [
          SvgPicture.string(
            categoryPreference.category.icon,
            width: AppDimens.l,
            height: AppDimens.l,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Text(
              categoryPreference.category.name,
              style: AppTypography.h4Medium.copyWith(height: 1),
            ),
          ),
          const SizedBox(width: AppDimens.xl),
          Switch.adaptive(
            value: categoryPreference.isPreferred,
            activeColor: AppColors.black,
            onChanged: onSwitch,
          ),
        ],
      ),
    );
  }
}
