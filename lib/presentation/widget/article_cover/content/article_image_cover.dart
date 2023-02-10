part of '../article_cover.dart';

class _ArticleSquareImageCover extends StatelessWidget {
  const _ArticleSquareImageCover({
    required this.article,
    required this.coverColor,
    required this.dimension,
    this.available = false,
  });

  final MediaItemArticle article;
  final Color? coverColor;
  final double dimension;
  final bool available;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: _ArticleImageCover(
        article: article,
        coverColor: coverColor,
        available: available,
      ),
    );
  }
}

class _ArticleAspectRatioImageCover extends StatelessWidget {
  const _ArticleAspectRatioImageCover({
    required this.article,
    required this.coverColor,
    required this.aspectRatio,
    required this.width,
    this.available = true,
  });

  final MediaItemArticle article;
  final Color? coverColor;
  final double aspectRatio;
  final double width;
  final bool available;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: _ArticleImageCover(
          article: article,
          coverColor: coverColor,
          available: available,
        ),
      ),
    );
  }
}

class _ArticleImageCover extends StatelessWidget {
  const _ArticleImageCover({
    required this.article,
    required this.coverColor,
    required this.available,
  });

  final MediaItemArticle article;
  final Color? coverColor;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final darkeningMode = article.locked ? DarkeningMode.solid : DarkeningMode.none;

    return Opacity(
      opacity: available ? 1 : AppDimens.unavailableItemOpacity,
      child: SizedBox.expand(
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
                      const Positioned.fill(
                        child: Center(
                          child: InformedSvg(
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
      ),
    );
  }
}
