import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/category_preference_follow_button/category_preference_follow_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/category_preference_follow_button/category_preference_follow_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
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
    final snackbarController = useSnackbarController();

    void showGuestErrorMessage() {
      snackbarController.showMessage(SnackbarMessage.guest(context));
    }

    useCubitListener<CategoryPreferenceFollowButtonCubit, CategoryPreferenceFollowButtonState>(cubit,
        (cubit, state, context) {
      state.whenOrNull(
        error: () {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: context.l10n.common_generalError,
              type: SnackbarMessageType.error,
            ),
          );
        },
      );
    });

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
      loading: (_) => SizedBox(
        height: AppDimens.m,
        width: AppDimens.m,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.of(context).iconPrimary,
            strokeWidth: AppDimens.xxs,
          ),
        ),
      ),
      guest: (_) => _Button(
        isPreferred: false,
        onTap: showGuestErrorMessage,
      ),
      categoryPreferenceLoaded: (state) => GestureDetector(
        child: _Button(
          isPreferred: state.categoryPreference.isPreferred,
          onTap: () => state.categoryPreference.isPreferred
              ? cubit.unfollowCategory(state.categoryPreference)
              : cubit.followCategory(state.categoryPreference),
        ),
      ),
      orElse: SizedBox.shrink,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.isPreferred,
    this.onTap,
  });

  final bool isPreferred;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: AppDimens.xl,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.s,
          horizontal: AppDimens.m,
        ),
        decoration: BoxDecoration(
          color:
              isPreferred ? AppColors.of(context).backgroundSecondary : AppColors.of(context).buttonPrimaryBackground,
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
                isPreferred ? context.l10n.common_unfollow : context.l10n.common_follow,
                style: AppTypography.buttonBold.copyWith(
                  color:
                      isPreferred ? AppColors.of(context).buttonSecondaryText : AppColors.of(context).buttonPrimaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
