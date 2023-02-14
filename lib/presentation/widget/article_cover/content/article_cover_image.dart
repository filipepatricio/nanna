part of '../article_cover.dart';

class _ArticleCoverImage extends StatelessWidget {
  const _ArticleCoverImage.square({
    required this.article,
    required this.dimension,
    this.available = false,
  })  : aspectRatio = null,
        width = null;

  const _ArticleCoverImage.aspectRatio({
    required this.article,
    required this.aspectRatio,
    required this.width,
    this.available = true,
  }) : dimension = null;

  final MediaItemArticle article;
  final double? aspectRatio;
  final double? dimension;
  final double? width;
  final bool available;

  @override
  Widget build(BuildContext context) {
    if (dimension != null) {
      return SizedBox.square(
        dimension: dimension,
        child: _CoverImage(
          article: article,
          available: available,
        ),
      );
    }

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectRatio!,
        child: _CoverImage(
          article: article,
          available: available,
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.article,
    required this.available,
  });

  final MediaItemArticle article;
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
                      cardColor: article.category.color,
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
                  color: article.category.color,
                  locked: article.locked,
                ),
        ),
      ),
    );
  }
}
