import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/add_interests/add_interests_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/add_interests/add_interests_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/bottom_list_fade_view.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widget/interest_list.dart';
part 'widget/interest_list_item.dart';
part 'widget/interest_list_loading.dart';

class AddInterestsPage extends HookWidget {
  const AddInterestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AddInterestsPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());
    final scrollController = useScrollController();

    useCubitListener<AddInterestsPageCubit, AddInterestsPageState>(cubit, (cubit, event, context) {
      event.mapOrNull(
        success: (_) => context.popRoute(),
        successTrial: (data) {
          context.router.replace(
            SubscriptionSuccessPageRoute(trialDays: data.trialDays, reminderDays: data.reminderDays),
          );
        },
        failure: (_) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: context.l10n.common_error_tryAgainLater,
              type: SnackbarMessageType.error,
            ),
          );
        },
      );
    });

    useEffect(
      () {
        cubit.init();
      },
      [cubit],
    );

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Scaffold(
          body: SnackbarParentView(
            controller: snackbarController,
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDimens.m),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.popRoute(),
                      child: Text(
                        context.l10n.common_skip,
                        style: AppTypography.sansTextSmallLausanne.copyWith(
                          color: AppColors.of(context).textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.m),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: Text(
                      context.l10n.addInterests_title,
                      style: AppTypography.sansTitleLargeLausanne,
                    ),
                  ),
                  const SizedBox(height: AppDimens.m),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: Text(
                      context.l10n.addInterests_description,
                      style: AppTypography.sansTextSmallLausanne.copyWith(color: AppColors.of(context).textSecondary),
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                  Expanded(
                    child: BottomListFadeView(
                      scrollController: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                        child: InformedAnimatedSwitcher(
                          child: state.maybeMap(
                            loading: (state) => const _InterestListLoading(),
                            idle: (state) => _InterestList(
                              categories: state.categories,
                              selectedCategories: state.selectedCategories,
                              onSelected: (category) => cubit.selectCategory(category),
                              onUnselected: (category) => cubit.unselectCategory(category),
                            ),
                            processing: (state) => _InterestList(
                              categories: state.categories,
                              selectedCategories: state.selectedCategories,
                              onSelected: (category) {},
                              onUnselected: (category) {},
                            ),
                            orElse: () => const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: InformedFilledButton.primary(
                      context: context,
                      text: context.l10n.common_continue,
                      isLoading: state.maybeMap(processing: (_) => true, orElse: () => false),
                      isEnabled: state.maybeMap(idle: (state) => state.isSelectionValid, orElse: () => false),
                      onTap: () {
                        cubit.apply();
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimens.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
