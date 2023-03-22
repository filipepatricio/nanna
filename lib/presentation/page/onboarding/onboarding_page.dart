import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_slide.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/informed_theme.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const _notificationSlide = 2;
const _trackingSlide = 2;

class OnboardingPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pageList = [
      OnboardingSlide(
        imagePath: AppRasterGraphics.onboardingSlideOne,
        title: context.l10n.onboarding_headerSlideOne,
        body: context.l10n.onboarding_descriptionSlideOne,
      ),
      OnboardingSlide(
        imagePath: AppRasterGraphics.onboardingSlideTwo,
        title: context.l10n.onboarding_headerSlideTwo,
        body: context.l10n.onboarding_descriptionSlideTwo,
      ),
      OnboardingSlide(
        imagePath: AppRasterGraphics.onboardingSlideThree,
        title: context.l10n.onboarding_headerSlideThree,
        body: context.l10n.onboarding_descriptionSlideThree,
      ),
    ];

    final cubit = useCubit<OnboardingPageCubit>();
    final snackbarController = useMemoized(() => SnackbarController());

    final pageIndex = useState(0);
    final controller = usePageController();
    final isLastPage = pageIndex.value == pageList.length - 1;
    final brightness = AdaptiveTheme.of(context).brightness;

    Future<void> openInBrowser(String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(context, uri, snackbarController);
        },
      );
    }

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

    useOnAppLifecycleStateChange((previous, current) {
      cubit.setUiActiveState(current == AppLifecycleState.resumed);
    });

    return AnnotatedRegion(
      value: brightness == Brightness.dark
          ? InformedTheme.systemUIOverlayStyleLight
          : InformedTheme.systemUIOverlayStyleDark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 20,
                child: Stack(
                  children: [
                    PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: controller,
                      onPageChanged: (index) {
                        cubit.trackOnboardingPage(index);
                        pageIndex.value = index;
                      },
                      children: pageList,
                    ),
                    Positioned(
                      top: AppDimens.s,
                      right: AppDimens.xl,
                      child: _SkipButton(
                        cubit: cubit,
                        controller: controller,
                      ),
                    ),
                    Positioned(
                      top: AppDimens.s,
                      left: AppDimens.xl,
                      child: _GiftButton(
                        cubit: cubit,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: Row(
                  children: [
                    SmoothPageIndicator(
                      controller: controller,
                      count: pageList.length,
                      effect: ExpandingDotsEffect(
                        expansionFactor: 4,
                        activeDotColor: AppColors.of(context).iconPrimary,
                        dotColor: AppColors.of(context).iconSecondary,
                        spacing: AppDimens.xs,
                        dotHeight: AppDimens.xs,
                        dotWidth: AppDimens.xs,
                        // strokeWidth: 5,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: AppDimens.xxl,
                      child: !isLastPage
                          ? _NextPageButton(
                              cubit: cubit,
                              controller: controller,
                              currentPage: pageIndex.value,
                            )
                          : const SizedBox.shrink(),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InformedFilledButton.primary(
                      context: context,
                      text: context.l10n.onboarding_button_getStartedWithPremium,
                      onTap: () => _navigateToMainPage(context, cubit),
                    ),
                    const SizedBox(height: AppDimens.s),
                    InformedFilledButton.tertiary(
                      context: context,
                      text: context.l10n.onboarding_button_alreadyHaveAnAccount,
                      onTap: () => _navigateToMainPage(context, cubit),
                      withOutline: true,
                    ),
                    const SizedBox(height: AppDimens.ml),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinkLabel(
                          label: context.l10n.settings_termsAndConditions,
                          style: AppTypography.sansTextNanoLausanne,
                          decoration: TextDecoration.none,
                          onTap: () => openInBrowser(''),
                        ),
                        const SizedBox(width: AppDimens.m),
                        LinkLabel(
                          label: context.l10n.settings_privacyPolicy,
                          style: AppTypography.sansTextNanoLausanne,
                          decoration: TextDecoration.none,
                          onTap: () => openInBrowser(''),
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
    return PaddingTapWidget(
      alignment: AlignmentDirectional.centerEnd,
      tapPadding: const EdgeInsets.all(AppDimens.l),
      onTap: () {
        controller.animateToPage(
          _notificationSlide,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
        cubit.trackOnboardingSkipped();
      },
      child: Text(
        context.l10n.common_skip,
        style: AppTypography.buttonSmallBold.copyWith(color: AppColors.brandPrimary),
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
    return PaddingTapWidget(
      alignment: AlignmentDirectional.centerEnd,
      tapPadding: const EdgeInsets.all(AppDimens.l),
      onTap: () async {
        await controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      },
      child: const InformedSvg(
        AppVectorGraphics.fullArrowRight,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _GiftButton extends StatelessWidget {
  const _GiftButton({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final OnboardingPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return PaddingTapWidget(
      alignment: AlignmentDirectional.centerStart,
      tapPadding: const EdgeInsets.all(AppDimens.l),
      onTap: () {
        //TODO:
      },
      child: const InformedSvg(
        AppVectorGraphics.gift,
        fit: BoxFit.contain,
        color: AppColors.brandPrimary,
      ),
    );
  }
}

Future<void> _navigateToMainPage(BuildContext context, OnboardingPageCubit cubit) async {
  await cubit.setOnboardingCompleted();
  if (context.mounted) {
    await context.router.replaceAll(
      [const MainPageRoute()],
    );
  }
}
