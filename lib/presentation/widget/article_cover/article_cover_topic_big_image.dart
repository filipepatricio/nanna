part of 'article_cover.dart';

class _ArticleCoverTopicBigImage extends StatelessWidget {
  const _ArticleCoverTopicBigImage({
    required this.article,
    this.editorsNote,
    this.onTap,
    Key? key,
  }) : super(key: key);
  final MediaItemArticle article;
  final String? editorsNote;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.m);
    final hasImage = article.hasImage;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: cardShadows,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              if (hasImage)
                Positioned.fill(
                  child: ArticleImage(
                    image: article.image!,
                    darkeningMode: DarkeningMode.solid,
                  ),
                ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimens.l),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                        child: Column(
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
                                  ),
                                ),
                                if (article.hasAudioVersion) AudioIconButton(article: article),
                              ],
                            ),
                            const SizedBox(height: AppDimens.m),
                            InformedMarkdownBody(
                              markdown: article.title,
                              baseTextStyle: AppTypography.h1Bold.copyWith(
                                color: AppColors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                              highlightColor: AppColors.transparent,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: AppDimens.l),
                          ArticleDottedInfo(
                            article: article,
                            isLight: true,
                            showPublisher: false,
                          ),
                          const Spacer(),
                          if (article.locked) const Locker.light(),
                          const SizedBox(width: AppDimens.l),
                        ],
                      ),
                      const SizedBox(height: AppDimens.l),
                      if (editorsNote != null)
                        ArticleEditorsNote(
                          note: editorsNote!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
