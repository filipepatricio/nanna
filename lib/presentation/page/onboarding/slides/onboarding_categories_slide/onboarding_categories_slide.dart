import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_categories_slide/onboarding_categories_slide_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _onboardingTopicCardAnimDurationMs = 200;
const _tileSize = 90.0;
const _tileSpacing = 16.0;

class OnboardingCategoriesSlide extends StatelessWidget {
  const OnboardingCategoriesSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AppDimens.safeTopPadding(context)),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: AutoSizeText(
            LocaleKeys.onboarding_headerSlideCategories.tr(),
            style: AppTypography.onBoardingHeader.copyWith(height: 1.14, fontSize: 34),
          ),
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: AutoSizeText(
            LocaleKeys.onboarding_descriptionSlideCategories.tr(),
            style: AppTypography.b2Regular,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final rows = constraints.maxHeight ~/ (_tileSize + _tileSpacing);
              return _MainContent(rows: rows);
            },
          ),
        ),
      ],
    );
  }
}

class _MainContent extends HookWidget {
  const _MainContent({
    required this.rows,
    Key? key,
  }) : super(key: key);

  final int rows;

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

    return Center(
      child: state.maybeMap(
        orElse: () => const Loader(),
        idle: (idleState) => Padding(
          padding: const EdgeInsets.only(top: AppDimens.xl),
          child: GridView(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rows,
              childAspectRatio: 1.0,
              crossAxisSpacing: _tileSpacing,
              mainAxisSpacing: _tileSpacing,
            ),
            children: [
              ...idleState.data.categories.map(
                (category) => _SelectableCard(
                  text: category.name,
                  isSelected: idleState.data.selectedCategories.contains(category),
                  onPressed: () => cubit.onCardPressed(category),
                  color: category.color,
                ),
              ),
              _SelectableCard(
                text: LocaleKeys.onboarding_categories_everything.tr(),
                isSelected: idleState.data.selectedCategories.isEmpty,
                onPressed: cubit.onAllCardPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.buttonRadius)),
        border: isSelected ? Border.all(color: AppColors.charcoal, width: 1.5) : null,
      ),
      width: _tileSize,
      height: _tileSize,
      duration: const Duration(milliseconds: _onboardingTopicCardAnimDurationMs),
      child: CupertinoButton(
        color: color ?? AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(AppDimens.buttonRadius)),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Center(
          child: AutoSizeText(
            text,
            style: AppTypography.b3Medium.copyWith(
              height: 1.2,
              letterSpacing: 0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
