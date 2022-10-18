part of 'article_cover.dart';

class _ArticleSquareCover extends StatelessWidget {
  const _ArticleSquareCover({
    required this.article,
    required this.coverColor,
    required this.dimension,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final double dimension;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.articleSmallImageCoverBorderRadius),
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
          if (article.hasAudioVersion)
            Positioned(
              bottom: AppDimens.s,
              right: AppDimens.s,
              child: AudioIconButton(article: article),
            ),
        ],
      ),
    );
  }
}
