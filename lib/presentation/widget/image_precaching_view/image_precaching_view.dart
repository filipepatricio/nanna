import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart' as domain;
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_config.dart';
import 'package:better_informed_mobile/presentation/widget/image_precaching_view/image_precaching_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/image_precaching_view/image_precaching_view_state.dt.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImagePrecachingView extends HookWidget {
  const ImagePrecachingView({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ImagePrecachingViewCubit>();
    final cloudinaryImageProvider = useCloudinaryProvider();

    useCubitListener<ImagePrecachingViewCubit, ImagePrecachingViewState>(
      cubit,
      (cubit, current, context) {
        if (kIsTest) return;

        current.mapOrNull(
          article: (data) => _precacheArticle(context, cloudinaryImageProvider, data.article),
          topic: (data) => _precacheTopic(context, cloudinaryImageProvider, data.topic),
        );
      },
    );

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return child;
  }

  Future<void> _precacheArticle(
    BuildContext context,
    CloudinaryImageProvider cloudinaryImageProvider,
    MediaItemArticle article,
  ) async {
    await _precacheArticleHeader(context, cloudinaryImageProvider, article);

    final articleImage = article.image?.cloudinaryImage;
    if (articleImage != null) {
      if (context.mounted) await _precacheMediumThumbnail(context, cloudinaryImageProvider, articleImage);
    }

    if (context.mounted) {
      await Future.wait(
        [
          ...[
            article.publisher.darkLogo,
            article.publisher.lightLogo,
          ].whereType<domain.Image>().map((image) => _precachePublisherLogo(context, cloudinaryImageProvider, image)),
        ],
      );
    }
  }

  Future<void> _precacheTopic(
    BuildContext context,
    CloudinaryImageProvider cloudinaryImageProvider,
    Topic topic,
  ) async {
    await _precacheTopicHeader(context, cloudinaryImageProvider, topic);

    if (context.mounted) await _precacheMediumThumbnail(context, cloudinaryImageProvider, topic.heroImage);

    final articles = topic.entries.map((e) => e.item).whereType<MediaItemArticle>();
    for (final article in articles) {
      if (context.mounted) await _precacheArticle(context, cloudinaryImageProvider, article);

      final articleImage = article.image?.cloudinaryImage;
      if (articleImage != null) {
        if (context.mounted) await _precacheLargeThumbnail(context, cloudinaryImageProvider, articleImage);
      }
    }
  }

  Future<void> _precacheArticleHeader(
    BuildContext context,
    CloudinaryImageProvider cloudinaryImageProvider,
    MediaItemArticle article,
  ) async {
    if (article.type != ArticleType.premium) return;

    final height = AppDimens.articleHeaderImageHeight(context);
    final width = AppDimens.articleHeaderImageWidth(context);

    final config = CloudinaryConfig(width: width, height: height);
    final articleImageUrl = article.imageUrl;

    if (articleImageUrl.isNotEmpty) {
      final url = config.applyAndGenerateUrl(context, articleImageUrl, cloudinaryImageProvider);
      await precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  Future<void> _precacheTopicHeader(
    BuildContext context,
    CloudinaryImageProvider cloudinaryImageProvider,
    Topic topic,
  ) async {
    final topicHeaderImageHeight = AppDimens.topicViewHeaderImageHeight(context);
    final topicHeaderImageWidth = AppDimens.topicViewHeaderImageWidth(context);

    final config = CloudinaryConfig(width: topicHeaderImageWidth, height: topicHeaderImageHeight);
    final publicId = topic.heroImage.publicId;

    final url = config.applyAndGenerateUrl(context, publicId, cloudinaryImageProvider);
    await precacheImage(CachedNetworkImageProvider(url), context);
  }

  Future<void> _precacheMediumThumbnail(
    BuildContext context,
    CloudinaryImageProvider cloudinaryImageProvider,
    domain.Image image,
  ) async {
    final width = AppDimens.coverSize(context, AppDimens.coverSizeToScreenWidthFactor);
    final height = width * AppDimens.articleSmallCoverAspectRatio;

    final config = CloudinaryConfig(width: width, height: height);

    final url = config.applyAndGenerateUrl(context, image.publicId, cloudinaryImageProvider);
    await precacheImage(CachedNetworkImageProvider(url), context);
  }

  Future<void> _precacheLargeThumbnail(
    BuildContext context,
    CloudinaryImageProvider cloudinaryImageProvider,
    domain.Image image,
  ) async {
    final width = MediaQuery.of(context).size.width;
    final height = width / AppDimens.articleLargeCoverAspectRatio;

    final config = CloudinaryConfig(width: width, height: height);

    final url = config.applyAndGenerateUrl(context, image.publicId, cloudinaryImageProvider);
    await precacheImage(CachedNetworkImageProvider(url), context);
  }

  Future<void> _precachePublisherLogo(
    BuildContext context,
    CloudinaryImageProvider cloudinaryImageProvider,
    domain.Image image,
  ) async {
    if (image.publicId.isEmpty) return;

    const size = AppDimens.ml;

    final url = cloudinaryImageProvider
        .withPublicId(image.publicId)
        .transform()
        .width(DimensionUtil.getPhysicalPixelsAsInt(size, context))
        .fit()
        .generateNotNull(image.publicId, imageType: ImageType.png);

    await precacheImage(CachedNetworkImageProvider(url), context);
  }
}

extension on ArticleImage {
  domain.Image? get cloudinaryImage => map(
        cloudinary: (image) => image.cloudinaryImage,
        remote: (_) => null,
        unknown: (_) => null,
      );
}
