import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/color_extension.dart';
import 'package:better_informed_mobile/presentation/util/theme_util.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PublisherLogoRow extends HookWidget {
  const PublisherLogoRow({
    required this.topic,
    this.blendWithBackground = false,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final bool blendWithBackground;

  @override
  Widget build(BuildContext context) {
    final publishers = topic.publisherInformation.highlightedPublishers;
    final remainingPublishersIndicator = topic.publisherInformation.remainingPublishersIndicator;

    return SizedBox(
      height: AppDimens.publisherLogoSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...publishers.map(
            (publisher) => Theme.of(context).isDark
                ? PublisherLogo.light(publisher: publisher)
                : PublisherLogo.dark(publisher: publisher),
          ),
          if (remainingPublishersIndicator != null)
            Text(
              remainingPublishersIndicator,
              textAlign: TextAlign.start,
              style: AppTypography.sansTextSmallLausanne.copyWith(
                color: AppColors.of(context).textSecondary.blendMultiply(
                      backgroundColor: blendWithBackground ? topic.category.color : null,
                    ),
                height: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}
