part of 'article_cover.dart';

const _articleLargeImageCoverHeight = 256.0;

class _ArticleCoverDailyBriefLarge extends StatelessWidget {
  const _ArticleCoverDailyBriefLarge({
    required this.article,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.m);
    final hasImage = article.hasImage;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: borderRadius),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            children: [
              SizedBox(
                height: _articleLargeImageCoverHeight,
                child: Stack(
                  children: [
                    if (hasImage) ...[
                      Positioned.fill(
                        child: ArticleImage(
                          image: article.image!,
                          darkeningMode: DarkeningMode.gradient,
                        ),
                      ),
                    ],
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppDimens.m,
                                AppDimens.m,
                                AppDimens.m,
                                AppDimens.ml,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: DottedArticleInfo(
                                          article: article,
                                          isLight: true,
                                          showDate: false,
                                          showReadTime: false,
                                          textStyle: AppTypography.metadata1Medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    article.strippedTitle,
                                    style: AppTypography.h4ExtraBold.copyWith(
                                      color: AppColors.white,
                                      overflow: TextOverflow.ellipsis,
                                      height: 1.7,
                                    ),
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Overlapping top border for editor's note
                          if (article.shouldShowArticleCoverNote)
                            Container(
                              height: AppDimens.m,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(AppDimens.m),
                                  topRight: Radius.circular(AppDimens.m),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (article.shouldShowArticleCoverNote)
                ArticleLabelsEditorsNote(
                  article: article,
                  coverType: ArticleCoverType.dailyBriefLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
