part of 'article_cover.dart';

class _ArticleCoverSmall extends ArticleCover {
  const _ArticleCoverSmall({
    required this.onTap,
    required this.article,
    Key? key,
  }) : super._(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;

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
            _ArticleSquareCover(
              article: article,
              coverColor: article.category.color,
              dimension: constraints.maxWidth,
            ),
            _ArticleCoverSmallContent(
              article: article,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCoverSmallContent extends StatelessWidget {
  const _ArticleCoverSmallContent({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    const titleMaxLines = 4;
    const titleStyle = AppTypography.articleSmallTitle;
    final titleHeight = AppDimens.textHeight(style: titleStyle, maxLines: titleMaxLines);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.s),
        PublisherRow(article: article),
        const SizedBox(height: AppDimens.s),
        SizedBox(
          height: titleHeight,
          child: InformedMarkdownBody(
            maxLines: titleMaxLines,
            markdown: article.title,
            highlightColor: AppColors.transparent,
            baseTextStyle: titleStyle,
          ),
        ),
        const SizedBox(height: AppDimens.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ArticleTimeReadLabel(
              finished: article.finished,
              timeToRead: article.timeToRead,
            ),
            const Spacer(),
            BookmarkButton.article(
              article: article,
            ),
          ],
        ),
      ],
    );
  }
}
