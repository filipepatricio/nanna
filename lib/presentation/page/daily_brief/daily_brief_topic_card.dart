import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DailyBriefTopicCard extends HookWidget {
  final int index;
  final Function() onPressed;
  final Topic topic;

  const DailyBriefTopicCard({
    required this.index,
    required this.onPressed,
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width * 2;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.s,
        top: AppDimens.xxxl,
        bottom: AppDimens.xxxl,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.topicCardRadius),
            boxShadow: [
              BoxShadow(
                offset: const Offset(AppDimens.zero, AppDimens.topicCardOffsetY),
                blurRadius: AppDimens.topicCardBlurRadius,
                color: AppColors.shadowColor,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimens.topicCardRadius),
                ),
                child: Hero(
                  tag: HeroTag.dailyBriefTopicImage(topic.id),
                  flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
                    final colorTween = ColorTween(
                      begin: AppColors.gradientOverlayEndColor,
                      end: AppColors.gradientOverlayStartColor,
                    ).animate(anim);

                    return AnimatedBuilder(
                      animation: colorTween,
                      builder: (context, child) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppDimens.topicCardRadius),
                                topRight: Radius.circular(AppDimens.topicCardRadius),
                              ),
                              child: Image.network(
                                CloudinaryImageExtension.withPublicId(topic.image.publicId)
                                    .transform()
                                    .width(imageWidth.ceil())
                                    .fit()
                                    .generate()!,
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.topLeft,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    colorTween.value!,
                                    AppColors.gradientOverlayEndColor,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Image.network(
                    CloudinaryImageExtension.withPublicId(topic.image.publicId)
                        .transform()
                        .width(imageWidth.ceil())
                        .fit()
                        .generate()!,
                    loadingBuilder: (context, widget, event) => widget,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.m),
              _Title(topic: topic),
              const SizedBox(height: AppDimens.m),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                  child: Hero(
                    tag: HeroTag.dailyBriefTopicSummary(topic.id),
                    flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
                      final colorTween = ColorTween(begin: AppColors.textPrimary, end: AppColors.white).animate(anim);

                      return Material(
                        color: Colors.transparent,
                        child: AnimatedBuilder(
                          animation: colorTween,
                          builder: (context, child) {
                            return InformedMarkdownBody(
                              markdown: topic.introduction,
                              baseTextStyle: AppTypography.b1Medium.copyWith(color: colorTween.value),
                            );
                          },
                        ),
                      );
                    },
                    child: InformedMarkdownBody(
                      markdown: topic.introduction,
                      baseTextStyle: AppTypography.b1Medium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final Topic topic;

  const _Title({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
      child: Hero(
        tag: HeroTag.dailyBriefTopicTitle(topic.id),
        flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
          final colorTween = ColorTween(begin: AppColors.textPrimary, end: AppColors.white).animate(anim);

          return Material(
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: colorTween,
              builder: (context, child) {
                return Text(
                  topic.title,
                  style: AppTypography.h1Bold.copyWith(color: colorTween.value),
                );
              },
            ),
          );
        },
        child: Text(
          topic.title,
          style: AppTypography.h1Bold,
        ),
      ),
    );
  }
}
