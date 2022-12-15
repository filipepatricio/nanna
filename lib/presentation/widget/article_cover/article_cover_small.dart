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
    const titleMaxLines = 4;
    const titleStyle = AppTypography.serifTitleSmallIvar;
    final titleHeight = AppDimens.textHeight(style: titleStyle, maxLines: titleMaxLines);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ArticleSquareCover(
              article: article,
              coverColor: article.category.color,
              dimension: constraints.maxWidth,
            ),
            const SizedBox(height: AppDimens.sl),
            PublisherRow(article: article),
            const SizedBox(height: AppDimens.sl),
            SizedBox(
              height: titleHeight,
              child: InformedMarkdownBody(
                maxLines: titleMaxLines,
                markdown: article.title,
                highlightColor: AppColors.transparent,
                baseTextStyle: titleStyle,
              ),
            ),
            const Spacer(),
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
        ),
      ),
    );
  }
}
