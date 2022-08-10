import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_categories_slide/onboarding_categories_slide.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_notifications_slide.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_picture_slide.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_tracking_slide.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

final List<Widget> _pageList = [
  OnboardingPictureSlide(
    title: LocaleKeys.onboarding_title.tr(),
    descriptionHeader: LocaleKeys.onboarding_headerSlideOne.tr(),
    description: LocaleKeys.onboarding_descriptionSlideOne.tr(),
    imageAsset: AppVectorGraphics.onboardingSlideOne,
  ),
  OnboardingPictureSlide(
    title: LocaleKeys.onboarding_title.tr(),
    descriptionHeader: LocaleKeys.onboarding_headerSlideTwo.tr(),
    description: LocaleKeys.onboarding_descriptionSlideTwo.tr(),
    imageAsset: AppVectorGraphics.onboardingSlideTwo,
  ),
  const OnboardingCategoriesSlide(),
  if (kIsAppleDevice) ...[
    const OnboardingNotificationsSlide(),
    const OnboardingTrackingSlide(),
  ]
];

const _notificationSlide = 3;
const _trackingSlide = 4;

class OnboardingPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OnboardingPageCubit>();

    final pageIndex = useState(0);
    final controller = usePageController();
    final isLastPage = pageIndex.value == _pageList.length - 1;

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<OnboardingPageCubit, OnboardingPageState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          jumpToTrackingPage: (_) {
            controller.jumpToPage(_trackingSlide);
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 20,
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  cubit.trackOnboardingPage(index);
                  pageIndex.value = index;
                },
                children: _pageList,
              ),
            ),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageDotIndicator(
                    pageCount: _pageList.length,
                    controller: controller,
                  ),
                  const SizedBox(height: AppDimens.m),
                  Row(
                    children: [
                      if (pageIndex.value == 0)
                        _SkipButton(
                          cubit: cubit,
                          controller: controller,
                        ),
                      const Spacer(),
                      if (isLastPage)
                        FilledButton(
                          text: LocaleKeys.common_continue.tr(),
                          fillColor: AppColors.limeGreen,
                          textColor: AppColors.textPrimary,
                          onTap: () => _navigateToMainPage(
                            context,
                            cubit,
                          ),
                        )
                      else
                        _NextPageButton(
                          cubit: cubit,
                          controller: controller,
                          currentPage: pageIndex.value,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.m),
          ],
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({
    required this.controller,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final PageController controller;
  final OnboardingPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        controller.animateToPage(
          _notificationSlide,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
        cubit.trackOnboardingSkipped();
      },
      child: Text(
        LocaleKeys.common_skip.tr(),
        style: AppTypography.buttonBold,
      ),
    );
  }
}

class _NextPageButton extends StatelessWidget {
  const _NextPageButton({
    required this.cubit,
    required this.controller,
    required this.currentPage,
    Key? key,
  }) : super(key: key);

  final OnboardingPageCubit cubit;
  final PageController controller;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (currentPage == _notificationSlide) {
          await cubit.requestNotificationPermission();
        }

        await controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      },
      icon: SvgPicture.asset(
        AppVectorGraphics.fullArrowRight,
        fit: BoxFit.contain,
      ),
    );
  }
}

Future<void> _navigateToMainPage(BuildContext context, OnboardingPageCubit cubit) async {
  await cubit.setOnboardingCompleted();
  await context.router.replaceAll([
    const MainPageRoute(),
  ]);
}
