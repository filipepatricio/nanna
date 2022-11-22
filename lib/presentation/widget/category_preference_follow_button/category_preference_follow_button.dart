import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/category_preference_follow_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/category_preference_follow_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategoryPreferenceFollowButton extends HookWidget {
  const CategoryPreferenceFollowButton({
    this.categoryPreference,
    this.category,
    Key? key,
  }) : super(key: key);

  final CategoryPreference? categoryPreference;
  final Category? category;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<CategoryPreferenceFollowButtonCubit>();
    final state = useCubitBuilder<CategoryPreferenceFollowButtonCubit, CategoryPreferenceFollowButtonState>(cubit);

    useEffect(
      () {
        cubit.initialize(
          categoryPreference: categoryPreference,
          category: category,
        );
      },
      [cubit],
    );

    return state.maybeMap(
      loading: (_) => const SizedBox(
        height: AppDimens.m,
        width: AppDimens.m,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.charcoal,
            strokeWidth: AppDimens.xxs,
          ),
        ),
      ),
      categoryPreferenceLoaded: (state) => GestureDetector(
        onTap: () => state.categoryPreference.isPreferred
            ? cubit.unfollowCategory(state.categoryPreference)
            : cubit.followCategory(state.categoryPreference),
        child: AnimatedContainer(
          height: AppDimens.xl,
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.s,
            horizontal: AppDimens.m,
          ),
          decoration: BoxDecoration(
            color: state.categoryPreference.isPreferred ? AppColors.lightGrey : AppColors.charcoal,
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  state.categoryPreference.isPreferred
                      ? LocaleKeys.common_following.tr()
                      : LocaleKeys.common_follow.tr(),
                  style: AppTypography.buttonBold.copyWith(
                    color: state.categoryPreference.isPreferred ? AppColors.textPrimary : AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      orElse: () => const SizedBox(),
    );
  }
}
