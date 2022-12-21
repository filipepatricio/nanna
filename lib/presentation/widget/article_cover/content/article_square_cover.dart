part of '../article_cover.dart';

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
        aspectRatio: aspectRatio,
        child: _ArticleImageCover(
          article: article,
          coverColor: coverColor,
        ),
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
    final darkeningMode = article.locked ? DarkeningMode.solid : DarkeningMode.none;

    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.defaultRadius),
        child: article.hasImage
            ? Stack(
                children: [
                  ArticleImage(
                    image: article.image!,
                    cardColor: coverColor,
                    darkeningMode: darkeningMode,
                  ),
                  if (article.locked)
                    Positioned.fill(
                      child: Center(
                        child: SvgPicture.asset(
                          AppVectorGraphics.locker,
                          color: AppColors.stateTextSecondary,
                        ),
                      ),
                    ),
                ],
              )
            : ArticleNoImageView(
                color: coverColor,
                locked: article.locked,
              ),
      ),
    );
  }
}
