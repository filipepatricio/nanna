import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsManageMyInterestsBody extends HookWidget {
  const SettingsManageMyInterestsBody({
    required this.categoryPreferences,
    required this.snackbarController,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final List<CategoryPreference> categoryPreferences;
  final SnackbarController snackbarController;
  final SettingsManageMyInterestsCubit cubit;

  @override
  Widget build(BuildContext context) {
    useCubitListener<SettingsManageMyInterestsCubit, SettingsManageMyInterestsState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showMessage: (message) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: message,
              type: SnackbarMessageType.negative,
            ),
          );
        },
      );
    });

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
                    .expand(
                      (element) => [
                        element,
                        const Divider(),
                      ],
                    ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: AudioPlayerBannerPlaceholder(),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.categoryPreference,
    required this.snackbarController,
    required this.cubit,
    required this.onSwitch,
    Key? key,
  }) : super(key: key);

  final CategoryPreference categoryPreference;
  final SnackbarController snackbarController;
  final SettingsManageMyInterestsCubit cubit;
  final Function(bool) onSwitch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Row(
        children: [
          Container(
            height: AppDimens.m,
            width: AppDimens.m,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: categoryPreference.category.color,
            ),
          ),
          const SizedBox(width: AppDimens.s),
          Expanded(
            child: Text(
              categoryPreference.category.name,
              style: AppTypography.b2Medium.copyWith(height: 1),
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
