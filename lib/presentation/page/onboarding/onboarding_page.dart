import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_slide.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/images.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OnboardingPage extends HookWidget {
  final List<OnboardingSlide> _pageList = <OnboardingSlide>[
    OnboardingSlide(
      title: 'onboarding.title'.tr(),
      descriptionHeader: 'onboarding.header_slide_one'.tr(),
      description: 'onboarding.description_slide_one'.tr(),
      imageAsset: ImagesSVG.onboardingSlideOne,
    ),
    OnboardingSlide(
      title: 'onboarding.title'.tr(),
      descriptionHeader: 'onboarding.header_slide_two'.tr(),
      description: 'onboarding.description_slide_two'.tr(), //TODO: GET FINAL TEXT
      imageAsset: ImagesSVG.onboardingSlideTwo.toString(),
    ),
    OnboardingSlide(
      title: 'onboarding.title'.tr(),
      descriptionHeader: 'onboarding.header_slide_three'.tr(),
      description: 'onboarding.description_slide_three'.tr(),
      imageAsset: ImagesSVG.onboardingSlideThree,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pageIndex = useState(0);
    final _controller = usePageController();
    final isLastPage = pageIndex.value == _pageList.length - 1;

    return Scaffold(
      backgroundColor: AppColors.black,
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
            padding: const EdgeInsets.all(AppDimens.xxxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.m),
                indicators(pageIndex, context),
                const SizedBox(height: AppDimens.xxl),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.limeGreen, width: 0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.ml),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      //TODO: NAVIGATE TO DASHBOARD
                    },
                    child: Text(
                      isLastPage ? 'common.continue'.tr() : 'common.skip'.tr(),
                      style: AppTypography.h2?.copyWith(color: AppColors.limeGreen),
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

  Container indicators(ValueNotifier<int> pageIndex, BuildContext context) {
    return Container(
      child: Row(
        children: List.generate(
          _pageList.length,
          (index) => buildDot(pageIndex.value, index, context),
        ),
      ),
    );
  }

  Container buildDot(int currentIndex, int index, BuildContext context) {
    return Container(
      height: AppDimens.indicatorSize,
      width: currentIndex == index ? AppDimens.indicatorSelectedSize : AppDimens.indicatorSize,
      margin: const EdgeInsets.only(right: AppDimens.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.ml),
        color: currentIndex == index ? AppColors.limeGreen : AppColors.limeGreenBleached,
      ),
    );
  }
}
