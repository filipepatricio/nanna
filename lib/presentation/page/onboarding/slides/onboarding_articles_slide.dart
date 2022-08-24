import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const _fakeTopicOwners = <TopicOwner>[
  Editor(bio: '', id: '', name: ''),
  Expert(bio: '', id: '', name: '', areaOfExpertise: ''),
];

const _space = SizedBox(height: AppDimens.l + AppDimens.xs);

class OnboardingArticlesSlide extends StatelessWidget {
  const OnboardingArticlesSlide({Key? key}) : super(key: key);

  List<Widget> get _columnOne => [
        const Flexible(child: _ArticleCard(AppRasterGraphics.placeholderOne, false)),
        _space,
        Flexible(child: _TopicCard(AppRasterGraphics.placeholderTwo, _fakeTopicOwners[1])),
        _space,
        const Flexible(child: _ArticleCard(AppRasterGraphics.placeholderThree, false)),
      ];

  List<Widget> get _columnTwo => [
        const Flexible(child: _ArticleCard(AppRasterGraphics.placeholderFour, true)),
        _space,
        const Flexible(child: _ArticleCard(AppRasterGraphics.placeholderFive, false)),
        _space,
        Flexible(child: _TopicCard(AppRasterGraphics.placeholderSix, _fakeTopicOwners[0])),
      ];

  List<Widget> get _columnThree => [
        const Flexible(child: _ArticleCard(AppRasterGraphics.placeholderSeven, false)),
        _space,
        const Flexible(child: _ArticleCard(AppRasterGraphics.placeholderEight, false)),
        _space,
        Flexible(child: _TopicCard(AppRasterGraphics.placeholderNine, _fakeTopicOwners[0])),
      ];

  List<Widget> _background(BuildContext context) => [
        Positioned(
          bottom: 0,
          left: -AppDimens.xl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _columnOne,
          ),
        ),
        Positioned(
          top: -AppDimens.s,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _columnTwo,
          ),
        ),
        Positioned(
          bottom: 0,
          right: -AppDimens.xl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _columnThree,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: AppDimens.safeTopPadding(context),
          color: AppColors.background,
        ),
        Expanded(
          flex: 13,
          child: AbsorbPointer(
            absorbing: true,
            child: Stack(
              alignment: Alignment.topCenter,
              children: _background(context),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.xl),
        Expanded(
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: AutoSizeText(
                    LocaleKeys.onboarding_headerSlideTwo.tr(),
                    style: AppTypography.h0Bold.copyWith(height: 1.14, fontSize: 34),
                    maxLines: 3,
                    stepGranularity: 0.1,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 10,
                  child: AutoSizeText(
                    LocaleKeys.onboarding_descriptionSlideTwo.tr(),
                    style: AppTypography.b2Regular,
                    maxLines: 4,
                    stepGranularity: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard(this.image, this.topicOwner, {Key? key}) : super(key: key);

  final String image;
  final TopicOwner topicOwner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.s),
      child: SizedBox.square(
        dimension: AppDimens.onboardingGridCard,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: AppDimens.s,
              left: AppDimens.s,
              child: CoverLabel.onboarding(owner: topicOwner),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard(this.image, this.hasAudioVersion, {Key? key}) : super(key: key);

  final String image;
  final bool hasAudioVersion;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.s),
      child: SizedBox.square(
        dimension: AppDimens.onboardingGridCard,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            if (hasAudioVersion)
              Positioned(
                bottom: AppDimens.s,
                right: AppDimens.s,
                child: SvgPicture.asset(
                  AppVectorGraphics.fakePlayButton,
                  width: AppDimens.xl,
                  height: AppDimens.xl,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
