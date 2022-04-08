import 'dart:async';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_author.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _logoHeight = 24.0;
const _cardRadius = 24.0;

class QuoteBackgroundView extends HookWidget implements BaseShareCompletable {
  QuoteBackgroundView({
    required this.article,
    Key? key,
  })  : _completer = Completer(),
        super(key: key);

  final MediaItemArticle article;
  final Completer _completer;

  @override
  Size get size => const Size(720, 1280);

  @override
  Completer get viewReadyCompleter => _completer;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final articleImageId = article.image?.publicId;

    final articleImage = useMemoized(
      () {
        if (articleImageId == null) return null;

        if (kIsTest) {
          return Image.asset(
            AppRasterGraphics.testArticleHeroImage,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          );
        }

        final imageUrl = cloudinary
            .withPublicId(articleImageId)
            .transform()
            .width(110)
            .height(110)
            .autoGravity()
            .autoQuality()
            .generateNotNull();

        return Image.network(
          imageUrl,
          width: 110,
          height: 110,
          fit: BoxFit.fill,
        );
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageLoadResolver(
        completer: viewReadyCompleter,
        images: [articleImage],
        child: Material(
          color: AppColors.background,
          child: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
              ),
              Positioned(
                left: AppDimens.xxxl,
                right: AppDimens.xxxl,
                bottom: AppDimens.xxxl,
                child: _ArticleBanner(
                  article: article,
                  image: articleImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleBanner extends StatelessWidget {
  const _ArticleBanner({
    required this.article,
    required this.image,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              tr(LocaleKeys.shareQuote_readOn),
              style: AppTypography.h1.copyWith(height: 1.0),
            ),
            SvgPicture.asset(
              AppVectorGraphics.informedLogoDark,
              height: _logoHeight,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.xl),
        Row(
          children: [
            if (image != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(_cardRadius),
                ),
                child: image!,
              ),
              const SizedBox(width: AppDimens.l),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.strippedTitle,
                    style: AppTypography.h1Headline(context).copyWith(fontSize: 32),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.s),
                  QuoteAuthor(
                    article: article,
                    style: AppTypography.h2Jakarta,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}