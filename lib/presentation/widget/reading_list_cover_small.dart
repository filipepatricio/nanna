import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReadingListCoverSmall extends HookWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const ReadingListCoverSmall({
    required this.topic,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: Stack(
            children: [
              Positioned.fill(
                child: CloudinaryProgressiveImage(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  cloudinaryTransformation: cloudinaryProvider
                      .withPublicId(topic.coverImage.publicId)
                      .transform()
                      .height(DimensionUtil.getPhysicalPixelsAsInt(constraints.maxHeight, context))
                      .fit(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimens.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TopicOwnerAvatar(
                      owner: topic.owner,
                      fontSize: 12,
                      imageWidth: AppDimens.avatarSize / 2,
                      imageHeight: AppDimens.avatarSize / 2,
                    ),
                    const SizedBox(height: AppDimens.m),
                    Expanded(
                      child: InformedMarkdownBody(
                        markdown: topic.title,
                        baseTextStyle: AppTypography.h5BoldSmall.copyWith(height: 1.5),
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: AppDimens.m),
                    Text(
                      LocaleKeys.readingList_articleCount.tr(args: [topic.readingList.entries.length.toString()]),
                      style: AppTypography.metadata1Regular.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
