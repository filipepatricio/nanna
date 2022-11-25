import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/category_preference_follow_button/category_preference_follow_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsManageMyInterestsBody extends HookWidget {
  const SettingsManageMyInterestsBody({
    required this.categoryPreferences,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final List<CategoryPreference> categoryPreferences;
  final SettingsManageMyInterestsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();

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

    return ListView(
      physics: getPlatformScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
      children: [
        ...categoryPreferences.map(
          (data) => _CategoryItem(
            categoryPreference: data,
            cubit: cubit,
          ),
        ),
        const AudioPlayerBannerPlaceholder(),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.categoryPreference,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final CategoryPreference categoryPreference;
  final SettingsManageMyInterestsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.c,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
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
          CategoryPreferenceFollowButton(
            categoryPreference: categoryPreference,
          ),
        ],
      ),
    );
  }
}
