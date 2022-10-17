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
      child: Container(
        color: AppColors.charcoal20,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ArticleSquareCover(
                article: article,
                coverColor: coverColor,
                dimension: constraints.maxWidth,
              ),
              _ArticleCoverContent(article: article),
            ],
          ),
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
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );

    return CoverOpacity.article(
      article: article,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            _ArticleSquareCover(
              article: article,
              coverColor: coverColor,
              dimension: coverSize,
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
                        PublisherLogo.dark(
                          publisher: article.publisher,
                          dimension: AppDimens.ml,
                        ),
                        Expanded(
                          child: Text(
                            article.publisher.name,
                            maxLines: 1,
                            style: AppTypography.caption1Medium.copyWith(color: AppColors.textGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (article.locked) const Locker.dark(),
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
                      child: ArticleDottedInfo(
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
      ),
    );
  }
}

class _ArticleCoverContent extends StatelessWidget {
  const _ArticleCoverContent({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    const titleMaxLines = 4;
    const titleStyle = AppTypography.metadata1ExtraBold;
    final titleHeight = AppDimens.textHeight(style: titleStyle, maxLines: titleMaxLines);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.m),
        SizedBox(
          height: AppDimens.m,
          child: ArticleDottedInfo(
            article: article,
            isLight: false,
            showLogo: true,
            showDate: false,
            showReadTime: false,
            color: AppColors.textGrey,
            textStyle: AppTypography.caption1Medium.copyWith(height: 1.1),
          ),
        ),
        const SizedBox(height: AppDimens.m),
        SizedBox(
          height: titleHeight,
          child: InformedMarkdownBody(
            maxLines: titleMaxLines,
            markdown: article.title,
            highlightColor: AppColors.transparent,
            baseTextStyle: titleStyle,
          ),
        ),
        const SizedBox(height: AppDimens.m),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TimeToRead(
              visited: article.visited,
              timeToRead: article.timeToRead,
            ),
            const Spacer(),
            Visibility(
              visible: article.locked,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: const Locker.dark(),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeToRead extends StatelessWidget {
  const _TimeToRead({
    required this.visited,
    required this.timeToRead,
    Key? key,
  }) : super(key: key);

  final bool visited;
  final int? timeToRead;

  @override
  Widget build(BuildContext context) {
    return visited
        ? Row(
            children: [
              const VisitedCheck(),
              const SizedBox(width: AppDimens.s),
              Text(
                LocaleKeys.article_read.tr(),
                style: AppTypography.caption1Medium.copyWith(
                  height: 1.2,
                  color: AppColors.textGrey,
                ),
              )
            ],
          )
        : Container(
            child: timeToRead == null
                ? const SizedBox()
                : Text(
                    LocaleKeys.article_readMinutes.tr(args: [timeToRead.toString()]),
                    style: AppTypography.caption1Medium.copyWith(
                      height: 1.2,
                      color: AppColors.textGrey,
                    ),
                  ),
          );
  }
}
