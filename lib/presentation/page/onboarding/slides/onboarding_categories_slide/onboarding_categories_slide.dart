import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_categories_slide/onboarding_categories_slide_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/flexible_wrap.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _onboardingTopicCardAnimDurationMs = 200;

class OnboardingCategoriesSlide extends StatelessWidget {
  const OnboardingCategoriesSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AppDimens.safeTopPadding(context)),
        const Spacer(),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
            child: AutoSizeText(
              tr(LocaleKeys.onboarding_headerSlideCategories),
              style: AppTypography.h0Bold.copyWith(height: 1.14, fontSize: 34),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
            child: AutoSizeText(
              LocaleKeys.onboarding_descriptionSlideCategories.tr(),
              style: AppTypography.b2Regular,
            ),
          ),
        ),
        const Expanded(
          flex: 15,
          child: _MainContent(),
        ),
      ],
    );
  }
}

class _MainContent extends HookWidget {
  const _MainContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OnboardingCategoriesSlideCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.init();
      },
      [cubit],
    );

    return state.maybeMap(
      orElse: () => const Loader(),
      idle: (idleState) => Padding(
        padding: const EdgeInsets.only(top: AppDimens.xl),
        child: FlexibleWrapWithHorizontalScroll(
          spacing: AppDimens.s,
          childrenBuilder: (width, height) => [
            _SelectableCard(
              icon: const Icon(
                Icons.add,
                color: AppColors.charcoal,
              ),
              height: height,
              width: width,
              text: LocaleKeys.onboarding_categories_everything.tr(),
              isSelected: idleState.data.selectedCategories.isEmpty,
              onPressed: cubit.onAllCardPressed,
            ),
            ...idleState.data.categories.map(
              (category) => _SelectableCard(
                icon: SvgPicture.string(category.icon),
                height: height,
                width: width,
                text: category.name,
                isSelected: idleState.data.selectedCategories.contains(category),
                onPressed: () => cubit.onCardPressed(category),
              ),
            ),
          ],
          childrenRowCount: 3,
        ),
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.width,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    required this.height,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          border: Border.all(
            color: isSelected ? AppColors.charcoal : AppColors.dividerGreyLight,
          ),
        ),
        width: width,
        height: height,
        duration: const Duration(milliseconds: _onboardingTopicCardAnimDurationMs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            icon,
            const SizedBox(height: AppDimens.s),
            Flexible(
              child: AutoSizeText(
                text,
                style: AppTypography.b3Medium.copyWith(height: 1.4),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
