import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_image.dart';
import 'package:flutter/material.dart';

class TopicSquareImageFrame extends StatelessWidget {
  const TopicSquareImageFrame({
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
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                  child: Text(
                    context.l10n.topic_label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTypography.h4Regular.copyWith(
                      height: 1.25,
                      color: AppColors.categoriesTextPrimary,
                    ),
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
