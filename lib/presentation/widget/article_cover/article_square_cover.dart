part of 'article_cover.dart';

class _ArticleSquareCover extends StatelessWidget {
  const _ArticleSquareCover({
    required this.article,
    required this.coverColor,
    required this.showArticleIndicator,
    required this.dimension,
    this.visited = false,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final bool showArticleIndicator;
  final double dimension;
  final double? borderRadius;
  final bool visited;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
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
          if (article.hasAudioVersion && !article.visited)
            Positioned(
              bottom: AppDimens.s,
              right: AppDimens.s,
              child: AudioIconButton(article: article),
            ),
          if (article.visited)
            const Positioned(
              bottom: AppDimens.s,
              right: AppDimens.s,
              child: VisitedCheck(),
            ),
        ],
      ),
    );
  }
}
