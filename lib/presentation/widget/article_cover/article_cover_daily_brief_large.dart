part of 'article_cover.dart';

class _ArticleCoverDailyBriefLarge extends StatelessWidget {
  const _ArticleCoverDailyBriefLarge({
    required this.article,
    this.editorsNote,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final String? editorsNote;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.m);
    final hasImage = article.hasImage;

    return Container(
      width: double.infinity,
      height: AppDimens.articleLargeImageCoverHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: articleCoverShadows,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            if (hasImage) ...[
              Positioned.fill(
                child: ArticleImage(
                  image: article.image!,
                  showDarkened: true,
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
                        AppDimens.l,
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
                                  showLogo: true,
                                  showPublisher: true,
                                  textStyle: AppTypography.metadata1Medium,
                                ),
                              ),
                              if (article.hasAudioVersion) AudioIcon.light(),
                            ],
                          ),
                          Text(
                            article.strippedTitle,
                            style: AppTypography.h4ExtraBold.copyWith(
                              color: AppColors.white,
                              overflow: TextOverflow.ellipsis,
                              height: 1.7,
                            ),
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ArticleLabelsEditorsNote(
                    note: editorsNote,
                    article: article,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
