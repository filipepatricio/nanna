part of 'article_cover.dart';

class _ArticleCoverExploreCarousel extends StatelessWidget {
  const _ArticleCoverExploreCarousel({
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
      behavior: HitTestBehavior.opaque,
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
                child: _CoverImage(
                  article: article,
                  coverColor: coverColor,
                  showArticleIndicator: true,
                ),
              ),
            ),
            ArticleCoverContent(article: article),
          ],
        ),
      ),
    );
  }
}

class _ArticleCoverExploreList extends HookWidget {
  const _ArticleCoverExploreList({
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
    final coverSize = useMemoized(
      () => MediaQuery.of(context).size.width * _coverSizeToScreenWidthFactor,
      [MediaQuery.of(context).size],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: coverSize,
            child: _CoverImage(
              article: article,
              coverColor: coverColor,
              showArticleIndicator: false,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: SizedBox(
              height: coverSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      PublisherLogo.dark(publisher: article.publisher),
                      Flexible(
                        child: Text(
                          article.publisher.name,
                          maxLines: 1,
                          style: AppTypography.caption1Medium.copyWith(color: AppColors.textGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    article.strippedTitle,
                    maxLines: 2,
                    style: AppTypography.h5BoldSmall.copyWith(height: 1.25),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Flexible(
                    child: DottedArticleInfo(
                      article: article,
                      isLight: false,
                      showLogo: false,
                      showPublisher: false,
                      fullDate: true,
                      textStyle: AppTypography.caption1Medium,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.article,
    required this.coverColor,
    required this.showArticleIndicator,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final bool showArticleIndicator;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            child: CoverLabel.audio(),
          ),
      ],
    );
  }
}
