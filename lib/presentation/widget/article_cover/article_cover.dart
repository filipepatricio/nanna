import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_cover_content.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:flutter/material.dart';

enum ArticleCoverType { explore }

class ArticleCover extends StatelessWidget {
  const ArticleCover._({
    required this.article,
    required this.type,
    this.coverColor,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final ArticleCoverType type;
  final MediaItemArticle article;
  final VoidCallback? onTap;
  final Color? coverColor;

  factory ArticleCover.explore({required MediaItemArticle article, Color? coverColor, VoidCallback? onTap}) =>
      ArticleCover._(
        type: ArticleCoverType.explore,
        article: article,
        coverColor: coverColor,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ArticleCoverType.explore:
        return _ArticleCoverExplore(
          onTap: onTap,
          article: article,
          coverColor: coverColor,
        );
    }
  }
}

class _ArticleCoverExplore extends StatelessWidget {
  const _ArticleCoverExplore({
    required this.onTap,
    required this.article,
    required this.coverColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;
  final Color? coverColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox.square(
              dimension: constraints.maxWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.s),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimens.s),
                        child: article.hasImage
                            ? ArticleImage(
                                image: article.image!,
                                cardColor: coverColor,
                                showDarkened: true,
                              )
                            : SizedBox.expand(
                                child: Container(color: coverColor),
                              ),
                      ),
                    ),
                    Positioned(
                      top: AppDimens.s,
                      left: AppDimens.s,
                      child: CoverLabel.article(),
                    ),
                    if (article.hasAudioVersion)
                      Positioned(
                        bottom: AppDimens.s,
                        right: AppDimens.s,
                        child: CoverLabel.audio(),
                      ),
                  ],
                ),
              ),
            ),
            ArticleCoverContent(article: article)
          ],
        ),
      ),
    );
  }
}
