import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

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
                      style: AppTypography.primaryTextJakarta,
                    ),
                    SizedBox(height: AppDimens.m),
                    Text(
                      'So far, only a handful of cases of cerebral thrombosis have arisen, compared with 45 million doses of various vaccines given in the European Union. AstraZeneca has accounted for about 13-15% of shots given since the rollout started in total.',
                      style: AppTypography.primaryTextJakarta,
                    ),
                    SizedBox(height: AppDimens.m),
                    Text(
                      'So far, only a handful of cases of cerebral thrombosis have arisen, compared with 45 million doses of various vaccines given in the European Union. AstraZeneca has accounted for about 13-15% of shots given since the rollout started in total.',
                      style: AppTypography.primaryTextJakarta,
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Hero(
          tag: 'image-$index',
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
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
                  Color(0xFF282B35),
                  Color(0x00282B35),
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
                  tag: 'title-$index',
                  child: Text(
                    'Title $index',
                    style: AppTypography.h1.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDimens.s),
                Hero(
                  tag: 'content-$index',
                  child: Text(
                    'Content $index. The Chinese Communist Party has long done everything it can to erase memories of the massacre of pro-democracy protesters in Beijing\'s Tiananmen Square 32-years-ago today.',
                    style: AppTypography.primaryTextJakarta.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
