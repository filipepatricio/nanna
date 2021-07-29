import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TopicView extends StatelessWidget {
  final int index;
  final AnimationController pageTransitionAnimation;

  const TopicView({
    required this.index,
    required this.pageTransitionAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _TopicHeader(index: index, pageTransitionAnimation: pageTransitionAnimation),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: AppDimens.l),
                    Text(
                      'So far, only a handful of cases of cerebral thrombosis have arisen, compared with 45 million doses of various vaccines given in the European Union. AstraZeneca has accounted for about 13-15% of shots given since the rollout started in total.',
                      style: AppTypography.b1Medium,
                    ),
                    SizedBox(height: AppDimens.m),
                    Text(
                      'So far, only a handful of cases of cerebral thrombosis have arisen, compared with 45 million doses of various vaccines given in the European Union. AstraZeneca has accounted for about 13-15% of shots given since the rollout started in total.',
                      style: AppTypography.b1Medium,
                    ),
                    SizedBox(height: AppDimens.m),
                    Text(
                      'So far, only a handful of cases of cerebral thrombosis have arisen, compared with 45 million doses of various vaccines given in the European Union. AstraZeneca has accounted for about 13-15% of shots given since the rollout started in total.',
                      style: AppTypography.b1Medium,
                    ),
                    SizedBox(height: AppDimens.l),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _TopicHeader extends HookWidget {
  final int index;
  final AnimationController pageTransitionAnimation;

  const _TopicHeader({
    required this.index,
    required this.pageTransitionAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => const ArticlePage(),
          useRootNavigator: true,
        );
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Hero(
            tag: HeroTag.dailyBriefTopicImage(index),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.65,
              child: Image.asset(
                'assets/image/topic_placeholder.png',
                fit: BoxFit.fitHeight,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.gradientOverlayStartColor,
                    AppColors.gradientOverlayEndColor,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeTransition(
                    opacity: pageTransitionAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.info)),
                        const SizedBox(height: AppDimens.m),
                        IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.share)),
                        const SizedBox(height: AppDimens.m),
                        IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.follow)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                  Hero(
                    tag: HeroTag.dailyBriefTopicTitle(index),
                    child: Text(
                      'Title $index',
                      style: AppTypography.h1Bold.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: AppDimens.s),
                  Hero(
                    tag: HeroTag.dailyBriefTopicSummary(index),
                    child: Text(
                      'Content $index. The Chinese Communist Party has long done everything it can to erase memories of the massacre of pro-democracy protesters in Beijing\'s Tiananmen Square 32-years-ago today.',
                      style: AppTypography.b1Medium.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
