import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PublisherLogoRow extends HookWidget {
  const PublisherLogoRow({
    required this.topic,
    this.mode = Brightness.dark,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final Brightness mode;

  @override
  Widget build(BuildContext context) {
    final publishers = topic.publisherInformation.highlightedPublishers;
    final remainingPublishersIndicator = topic.publisherInformation.remainingPublishersIndicator;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...publishers.map(
          (publisher) => mode == Brightness.dark
              ? PublisherLogo.dark(publisher: publisher)
              : PublisherLogo.light(publisher: publisher),
        ),
        if (remainingPublishersIndicator != null)
          Text(
            remainingPublishersIndicator,
            textAlign: TextAlign.start,
            style: AppTypography.b2Regular.copyWith(
              color: mode == Brightness.dark ? AppColors.textPrimary : AppColors.white,
              height: 1.2,
            ),
          ),
      ],
    );
  }
}
