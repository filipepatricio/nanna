part of 'article_cover.dart';

class _ArticleCoverDailyBriefSmall extends StatelessWidget {
  const _ArticleCoverDailyBriefSmall({
    required this.article,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(AppDimens.m));
    final hasImage = article.hasImage;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.one),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: CoverOpacity.article(
            article: article,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: AppColors.darkLinen,
                        width: AppDimens.one,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.m),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: ArticleDottedInfo(
                                      article: article,
                                      isLight: true,
                                      showDate: false,
                                      showReadTime: false,
                                      textStyle: AppTypography.metadata1Medium,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: (!article.shouldShowArticleCoverNote && article.hasAudioVersion)
                                    ? AppDimens.s
                                    : AppDimens.m,
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
                                        darkeningMode: DarkeningMode.none,
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
                                        color: AppColors.charcoal,
                                        overflow: TextOverflow.ellipsis,
                                        height: 1.7,
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              if (!article.shouldShowArticleCoverNote) ...[
                                const SizedBox(height: AppDimens.l),
                                ArticleLabelsSection(
                                  article: article,
                                  bookmarkButtonColor: AppColors.charcoal,
                                  audioFloatingControlButtonMode: AudioFloatingControlButtonMode.colored,
                                  lockerMode: LockerMode.color,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (article.shouldShowArticleCoverNote) ArticleLabelsEditorsNote(article: article),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
