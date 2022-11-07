import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareArticleViewContent extends StatelessWidget {
  const ShareArticleViewContent({
    required this.article,
    required this.publisherImage,
    required this.titleMaxLines,
    this.withInformedLogo = false,
    super.key,
  });

  final MediaItemArticle article;
  final Image? publisherImage;
  final int titleMaxLines;
  final bool withInformedLogo;

  @override
  Widget build(BuildContext context) {
    final author = article.author;
    final publisherImage = this.publisherImage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (publisherImage != null) ...[
              publisherImage,
              const SizedBox(width: AppDimens.s),
            ],
            Expanded(
              child: Text(
                article.publisher.name,
                style: AppTypography.b1Medium.copyWith(
                  height: 1,
                  fontSize: 24,
                  fontWeight: FontWeight.lerp(
                    FontWeight.w500,
                    FontWeight.w600,
                    0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.m),
        Text(
          article.strippedTitle,
          style: AppTypography.articleQuote.copyWith(
            fontSize: 36,
            height: 1.1,
            fontWeight: FontWeight.lerp(
              FontWeight.w500,
              FontWeight.w600,
              0.5,
            ),
          ),
          maxLines: titleMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (author != null) ...[
          const SizedBox(height: AppDimens.m),
          Text(
            LocaleKeys.shareArticle_author.tr(
              args: [
                author,
              ],
            ),
            style: AppTypography.b1Regular.copyWith(
              fontSize: 24,
              height: 1,
            ),
          ),
        ],
        if (withInformedLogo) ...[
          const SizedBox(height: AppDimens.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Align(
              alignment: Alignment.centerRight,
              child: SvgPicture.asset(
                AppVectorGraphics.launcherLogoInformed,
                width: 140,
                height: 32,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
