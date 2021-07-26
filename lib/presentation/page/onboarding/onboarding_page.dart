import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_slide.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/indicators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OnboardingPage extends HookWidget {
  final List<OnboardingSlide> _pageList = <OnboardingSlide>[
    OnboardingSlide(
      title: LocaleKeys.onboarding_title.tr(),
      descriptionHeader: LocaleKeys.onboarding_header_slide_one.tr(),
      description: LocaleKeys.onboarding_description_slide_one.tr(),
      imageAsset: AppVectorGraphics.onboardingSlideOne,
    ),
    OnboardingSlide(
      title: LocaleKeys.onboarding_title.tr(),
      descriptionHeader: LocaleKeys.onboarding_header_slide_two.tr(),
      description: LocaleKeys.onboarding_description_slide_two.tr(), //TODO: Change for final text
      imageAsset: AppVectorGraphics.onboardingSlideTwo,
    ),
    OnboardingSlide(
      title: LocaleKeys.onboarding_title.tr(),
      descriptionHeader: LocaleKeys.onboarding_header_slide_three.tr(),
      description: LocaleKeys.onboarding_description_slide_three.tr(),
      imageAsset: AppVectorGraphics.onboardingSlideThree,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pageIndex = useState(0);
    final _controller = usePageController();
    final isLastPage = pageIndex.value == _pageList.length - 1;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) => pageIndex.value = index,
              children: _pageList,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Indicators(currentIndex: pageIndex.value, pageListLength: _pageList.length),
                const SizedBox(height: AppDimens.xxl),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.limeGreen, width: AppDimens.one),
                    borderRadius: const BorderRadius.all(Radius.circular(AppDimens.s)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      //TODO: NAVIGATE TO DASHBOARD
                    },
                    child: Text(
                      isLastPage ? LocaleKeys.common_continue.tr() : LocaleKeys.common_skip.tr(),
                      style: AppTypography.h2Jakarta.copyWith(color: AppColors.limeGreen),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
