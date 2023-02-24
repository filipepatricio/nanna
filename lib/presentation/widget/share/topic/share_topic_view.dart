import 'dart:async';

import 'package:better_informed_mobile/domain/image/data/image.dart' as image_data;
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/shadows.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _stickerWidth = 480.0;
const _stickerMaxHeight = 640.0;

const _backgroundWidth = 720.0;
const _backgroundHeight = 1280.0;

class ShareTopicStickerView extends HookWidget implements BaseShareCompletable {
  ShareTopicStickerView({
    required this.topic,
    super.key,
  });

  final TopicPreview topic;

  final Completer _baseViewCompleter = Completer();

  @override
  Size get size => const Size(_stickerWidth, _stickerMaxHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();

    final publisherImages = useMemoized(() {
      return topic.publisherInformation.highlightedPublishers
          .map((publisher) => publisher.darkLogo)
          .whereType<image_data.Image>()
          .map(
            (logo) => cloudinaryImageAuto(
              cloudinary: cloudinary,
              publicId: logo.publicId,
              width: AppDimens.xl,
              height: AppDimens.xl,
              fit: BoxFit.contain,
              testImage: AppRasterGraphics.testPublisherLogoDark,
              imageType: ImageType.png,
            ),
          );
    });
    final topicOwnerImage = useMemoized(() => _topicOwnerImage(cloudinary));

    return ImageLoadResolver(
      completer: _baseViewCompleter,
      images: [topicOwnerImage, ...publisherImages],
      child: Center(
        child: Material(
          color: AppColors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.xl),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: topic.category.color ?? AppColors.of(context).backgroundPrimary,
              borderRadius: BorderRadius.circular(4),
              boxShadow: cardShadows,
            ),
            constraints: const BoxConstraints(
              maxHeight: _stickerMaxHeight,
              maxWidth: _stickerWidth,
              minWidth: _stickerWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  topic.strippedTitle,
                  style: AppTypography.h1Headline.w550.copyWith(
                    color: AppColors.categoriesTextPrimary,
                    fontSize: 64,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimens.xl),
                Center(
                  child: topicOwnerImage == null
                      ? const InformedSvg(
                          AppVectorGraphics.editorialTeamAvatar,
                          width: 64,
                          height: 64,
                          colored: false,
                        )
                      : ClipOval(child: topicOwnerImage),
                ),
                const SizedBox(height: AppDimens.m),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: AppTypography.h2Regular.copyWith(
                      color: AppColors.categoriesTextPrimary,
                      height: 1,
                    ),
                    children: [
                      TextSpan(
                        text: topic.curationInfo.byline,
                        style: AppTypography.h2Regular.copyWith(
                          color: AppColors.categoriesTextPrimary,
                          height: 1,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: topic.curationInfo.curator.name,
                        style: AppTypography.h2Regular.w550.copyWith(
                          color: AppColors.categoriesTextPrimary,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...publisherImages.expand((element) => [element, const SizedBox(width: AppDimens.s)]).toList(),
                    const SizedBox(width: AppDimens.m),
                    Text(
                      context.l10n.shareTopic_articlesCount(topic.entryCount),
                      style: AppTypography.b1Regular.copyWith(
                        height: 1,
                        color: AppColors.categoriesTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.xxl),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: Center(
                    child: InformedSvg(
                      AppVectorGraphics.launcherLogoInformed,
                      width: 140,
                      height: 32,
                      color: AppColors.categoriesTextPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.s),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Image? _topicOwnerImage(CloudinaryImageProvider cloudinary) {
    final avatar = topic.curationInfo.curator.avatar;

    if (avatar != null) {
      return cloudinaryImageAuto(
        cloudinary: cloudinary,
        publicId: avatar.publicId,
        width: 64,
        height: 64,
        testImage: AppRasterGraphics.expertAvatar,
      );
    }
  }
}

class ShareTopicBackgroundView extends HookWidget implements BaseShareCompletable {
  ShareTopicBackgroundView({
    required this.topic,
    super.key,
  });

  final TopicPreview topic;

  final Completer _baseViewCompleter = Completer();

  @override
  Size get size => const Size(_backgroundWidth, _backgroundHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();

    final backgroundImage = useMemoized(() {
      return cloudinaryImageAuto(
        cloudinary: cloudinary,
        publicId: topic.heroImage.publicId,
        width: _backgroundWidth,
        height: _backgroundHeight,
        fit: BoxFit.cover,
      );
    });

    return ImageLoadResolver(
      images: [backgroundImage],
      completer: _baseViewCompleter,
      child: backgroundImage,
    );
  }
}

class ShareTopicCombinedView extends HookWidget implements BaseShareCompletable {
  ShareTopicCombinedView({
    required this.topic,
    super.key,
  });

  final TopicPreview topic;

  final Completer _baseViewCompleter = Completer();

  @override
  Size get size => const Size(_backgroundWidth, _backgroundHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final background = useMemoized(() => ShareTopicBackgroundView(topic: topic));
    final foreground = useMemoized(() => ShareTopicStickerView(topic: topic));

    _baseViewCompleter.complete(
      Future.wait(
        [
          background.viewReadyCompleter.future,
          foreground.viewReadyCompleter.future,
        ],
      ),
    );

    return Stack(
      children: [
        background,
        Positioned.fill(
          child: Center(
            child: foreground,
          ),
        ),
      ],
    );
  }
}
