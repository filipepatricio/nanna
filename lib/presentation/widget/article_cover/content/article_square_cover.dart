import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:flutter/material.dart';

class ArticleSquareCover extends StatelessWidget {
  const ArticleSquareCover({
    required this.article,
    required this.coverColor,
    required this.showArticleIndicator,
    required this.dimension,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final bool showArticleIndicator;
  final double dimension;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.s),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius ?? AppDimens.s),
                child: article.hasImage
                    ? ArticleImage(
                        image: article.image!,
                        cardColor: coverColor,
                      )
                    : SizedBox.expand(
                        child: Container(color: coverColor),
                      ),
              ),
            ),
            if (showArticleIndicator)
              Positioned(
                top: AppDimens.s,
                left: AppDimens.s,
                child: CoverLabel.article(),
              ),
            if (article.hasAudioVersion)
              Positioned(
                bottom: AppDimens.s,
                right: AppDimens.s,
                child: AudioIconButton(article: article),
              ),
          ],
        ),
      ),
    );
  }
}
