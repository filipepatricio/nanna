part of 'article_cover.dart';

class _ArticleCoverTopicWithoutImage extends StatelessWidget {
  const _ArticleCoverTopicWithoutImage({
    required this.article,
    required this.backgroundColor,
    this.editorsNote,
    this.onTap,
    Key? key,
  }) : super(key: key);
  final MediaItemArticle article;
  final Color backgroundColor;
  final String? editorsNote;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimens.m),
          boxShadow: articleCoverShadows,
        ),
        width: double.infinity,
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
                            isLight: false,
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
                      baseTextStyle: AppTypography.h1SemiBold,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.l, bottom: AppDimens.l),
                child: ArticleDottedInfo(
                  article: article,
                  showPublisher: false,
                  isLight: false,
                ),
              ),
              if (editorsNote != null)
                ArticleEditorsNote(
                  note: editorsNote!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
