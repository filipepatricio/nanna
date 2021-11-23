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
    final _controller = usePageController();
    final isLastPage = pageIndex.value == _pageList.length - 1;

    useEffect(() {
      cubit.trackOnboardingStarted();
      cubit.trackOnboardingPage(0);
    }, [cubit]);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                cubit.trackOnboardingPage(index);
                pageIndex.value = index;
              },
              children: _pageList,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageDotIndicator(
                  pageCount: _pageList.length,
                  controller: _controller,
                ),
                const SizedBox(height: AppDimens.c),
                Row(
                  children: [
                    if (!isLastPage) ...[
                      TextButton(
                        onPressed: () => _navigateToMainPage(context, cubit, isLastPage),
                        child: Text(
                          LocaleKeys.common_skip.tr(),
                          style: AppTypography.buttonBold,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (isLastPage)
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.limeGreen,
                          borderRadius: BorderRadius.all(Radius.circular(AppDimens.s)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                          child: TextButton(
                            onPressed: () => _navigateToMainPage(context, cubit, isLastPage),
                            child: Text(
                              LocaleKeys.common_continue.tr(),
                              style: AppTypography.buttonBold,
                            ),
                          ),
                        ),
                      )
                    else
                      IconButton(
                        onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        ),
                        icon: SvgPicture.asset(
                          AppVectorGraphics.fullArrowRight,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMainPage(BuildContext context, OnboardingPageCubit cubit, bool isLastPage) {
    if (isLastPage) {
      cubit.trackOnboardingCompleted();
    } else {
      cubit.trackOnboardingSkipped();
    }
    cubit.requestNotificationPermission();
    AutoRouter.of(context).replaceAll(
      [
        const MainPageRoute(),
      ],
    );
  }
}
