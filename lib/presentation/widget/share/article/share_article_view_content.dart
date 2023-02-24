import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

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
                style: AppTypography.b1Medium.w550.copyWith(
                  color: AppColors.categoriesTextPrimary,
                  height: 1,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.m),
        Text(
          article.strippedTitle,
          style: AppTypography.articleQuote.w550.copyWith(
            color: AppColors.categoriesTextPrimary,
            fontSize: 36,
            height: 1.1,
          ),
          maxLines: titleMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (author != null) ...[
          const SizedBox(height: AppDimens.m),
          Text(
            context.l10n.shareArticle_author(author),
            style: AppTypography.b1Regular.copyWith(
              color: AppColors.categoriesTextPrimary,
              fontSize: 24,
              height: 1,
            ),
          ),
        ],
        if (withInformedLogo) ...[
          const SizedBox(height: AppDimens.xxl),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Align(
              alignment: Alignment.centerRight,
              child: InformedSvg(
                AppVectorGraphics.launcherLogoInformed,
                width: 140,
                height: 32,
                color: AppColors.categoriesTextPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
