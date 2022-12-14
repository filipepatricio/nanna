import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_image.dart';
import 'package:flutter/material.dart';

class TopicCoverImage extends StatelessWidget {
  const TopicCoverImage({
    required this.topic,
    required this.size,
    this.borderRadius = AppDimens.defaultRadius,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final double borderRadius;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.square(
          dimension: size,
          child: TopicImage(
            topic: topic,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size * 0.25,
              width: size * 0.7,
              decoration: BoxDecoration(
                color: topic.category.color,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(
                    AppDimens.defaultRadius,
                  ),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                  child: Text(
                    LocaleKeys.topic_label.tr(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTypography.h4Regular.copyWith(height: 1.25),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
