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

  Positioned get _leftColumnImages => Positioned(
        bottom: AppDimens.zero,
        right: AppDimens.onboardingGridCard + AppDimens.l + AppDimens.xs,
        left: -(AppDimens.onboardingGridCard + AppDimens.l + AppDimens.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _ArticleCard(AppRasterGraphics.placeholderOne, false),
            _space,
            _TopicCard(AppRasterGraphics.placeholderTwo, _fakeTopicOwners[1]),
            _space,
            const _ArticleCard(AppRasterGraphics.placeholderThree, false),
          ],
        ),
      );

  Positioned _centerColumnImages(BuildContext context) => Positioned(
        left: AppDimens.zero,
        right: AppDimens.zero,
        bottom: -(AppDimens.onboardingGridCard * 0.65),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _ArticleCard(AppRasterGraphics.placeholderFour, true),
            _space,
            const _ArticleCard(AppRasterGraphics.placeholderFive, false),
            _space,
            _TopicCard(AppRasterGraphics.placeholderSix, _fakeTopicOwners[0]),
          ],
        ),
      );

  Positioned get _rightColumnImages => Positioned(
        bottom: AppDimens.zero,
        right: -(AppDimens.onboardingGridCard + AppDimens.l + AppDimens.xs),
        left: AppDimens.onboardingGridCard + AppDimens.l + AppDimens.xs,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _ArticleCard(AppRasterGraphics.placeholderSeven, false),
            _space,
            const _ArticleCard(AppRasterGraphics.placeholderEight, false),
            _space,
            _TopicCard(AppRasterGraphics.placeholderNine, _fakeTopicOwners[0]),
          ],
        ),
      );

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
          child: ClipRRect(
            child: Transform.scale(
              scale: MediaQuery.of(context).size.width * 0.0025,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _leftColumnImages,
                  _centerColumnImages(context),
                  _rightColumnImages,
                ],
              ),
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
