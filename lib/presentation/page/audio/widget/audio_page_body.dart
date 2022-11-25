part of '../audio_page.dart';

class _AudioPageBody extends StatelessWidget {
  const _AudioPageBody({
    required this.article,
    required this.audioFile,
  });

  final MediaItemArticle article;
  final AudioFile audioFile;

  @override
  Widget build(BuildContext context) {
    final credits = audioFile.credits;

    return SafeArea(
      top: false,
      bottom: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (article.hasImage)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ArticleAudioViewCover(
                    article: article,
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    shouldShowTimeToRead: false,
                  );
                },
              ),
            )
          else
            Expanded(
              child: Container(
                color: article.category.color,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.ml),
                ArticleDottedInfo(
                  article: article,
                  isLight: false,
                  showLogo: true,
                  showReadTime: false,
                  showDate: false,
                  textStyle: _metadataStyle,
                  color: _metadataStyle.color,
                  centerContent: true,
                ),
                const SizedBox(height: AppDimens.s),
                Text(
                  article.strippedTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.articleH0SemiBold,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                if (credits != null && credits.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.s),
                  Text(
                    credits,
                    textAlign: TextAlign.center,
                    style: _metadataStyle.copyWith(
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: AppDimens.xl),
                AudioProgressBar(
                  article: article,
                ),
                const SizedBox(height: AppDimens.xl),
                _AudioComponentsView(article: article),
                const SizedBox(height: AppDimens.xl),
                const Center(
                  child: AudioSpeedButton(),
                ),
                const SizedBox(height: AppDimens.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
