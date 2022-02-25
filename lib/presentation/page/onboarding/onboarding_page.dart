import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_notifications_slide.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_picture_slide.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends HookWidget {
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
    const OnboardingNotificationsSlide(),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OnboardingPageCubit>();

    final pageIndex = useState(0);
    final controller = usePageController();
    final isLastPage = pageIndex.value == _pageList.length - 1;

    useEffect(
      () {
        cubit.trackOnboardingStarted();
        cubit.trackOnboardingPage(0);
      },
      [cubit],
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
                      if (!isLastPage)
                        _SkipButton(
                          cubit: cubit,
                          isLastPage: isLastPage,
                        ),
                      const Spacer(),
                      if (isLastPage)
                        FilledButton(
                          text: LocaleKeys.common_continue.tr(),
                          fillColor: AppColors.limeGreen,
                          textColor: AppColors.textPrimary,
                          onTap: () => _navigateToMainPage(context, cubit, isLastPage),
                        )
                      else
                        _NextPageButton(controller: controller),
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
    required this.cubit,
    required this.isLastPage,
    Key? key,
  }) : super(key: key);

  final OnboardingPageCubit cubit;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => _navigateToMainPage(context, cubit, isLastPage),
      child: Text(
        LocaleKeys.common_skip.tr(),
        style: AppTypography.buttonBold,
      ),
    );
  }
}

class _NextPageButton extends StatelessWidget {
  const _NextPageButton({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      ),
      icon: SvgPicture.asset(
        AppVectorGraphics.fullArrowRight,
        fit: BoxFit.contain,
      ),
    );
  }
}

Future<void> _navigateToMainPage(
  BuildContext context,
  OnboardingPageCubit cubit,
  bool isLastPage,
) async {
  final isSkipped = !isLastPage;
  await cubit.setOnboardingCompleted(isSkipped);
  await cubit.requestNotificationPermission();
  await AutoRouter.of(context).replaceAll(
    [
      const MainPageRoute(),
    ],
  );
}
