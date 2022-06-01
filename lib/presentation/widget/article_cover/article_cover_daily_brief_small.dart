part of 'article_cover.dart';

class _ArticleCoverDailyBriefSmall extends StatelessWidget {
  const _ArticleCoverDailyBriefSmall({
    required this.article,
    this.coverColor,
    this.editorsNote,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final String? editorsNote;
  final Color? coverColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.m);
    final hasImage = article.hasImage;

    return Container(
      width: double.infinity,
      height: AppDimens.articleSmallImageCoverHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: articleCoverShadows,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: coverColor ?? AppColors.mockedColors[0],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.m),
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
                                  color: AppColors.textGrey,
                                ),
                              ),
                              if (article.hasAudioVersion) AudioIcon.dark(),
                            ],
                          ),
                          Row(
                            children: [
                              if (hasImage) ...[
                                Container(
                                  width: AppDimens.xxxc,
                                  height: AppDimens.xxxc,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppDimens.xs),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: ArticleImage(
                                    image: article.image!,
                                    showDarkened: false,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: AppDimens.s + AppDimens.xxs,
                                ),
                              ],
                              Flexible(
                                child: Text(
                                  article.strippedTitle,
                                  style: AppTypography.h4ExtraBold.copyWith(
                                    color: AppColors.darkGreyBackground,
                                    overflow: TextOverflow.ellipsis,
                                    height: 1.7,
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                            ],
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
