part of 'article_cover.dart';

class _ArticleSquareCover extends StatelessWidget {
  const _ArticleSquareCover({
    required this.article,
    required this.coverColor,
    required this.dimension,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: _ArticleImageCover(article: article, coverColor: coverColor),
    );
  }
}

class _ArticleAspectRatioCover extends StatelessWidget {
  const _ArticleAspectRatioCover({
    required this.article,
    required this.coverColor,
    required this.aspectRatio,
    required this.width,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final double aspectRatio;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 6 / 5,
        child: _ArticleImageCover(article: article, coverColor: coverColor),
      ),
    );
  }
}

class _ArticleImageCover extends StatelessWidget {
  const _ArticleImageCover({
    required this.article,
    required this.coverColor,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      ],
    );
  }
}
