part of 'article_cover.dart';

class _ArticleCoverBookmarkList extends StatelessWidget {
  const _ArticleCoverBookmarkList({
    required this.article,
    required this.width,
    required this.height,
    this.cardColor = AppColors.transparent,
    this.shouldShowTextOverlay = true,
    this.shouldShowAudioIcon = true,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final double width;
  final double height;
  final Color cardColor;
  final bool shouldShowTextOverlay;
  final bool shouldShowAudioIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = article.hasImage;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          if (hasImage)
            ArticleImage(
              image: article.image!,
              cardColor: cardColor,
              darkeningMode: DarkeningMode.solid,
            )
          else
            Container(
              color: cardColor,
              width: width,
              height: height,
            ),
          if (shouldShowTextOverlay)
            _ArticleImageOverlay(
              article: article,
              height: height,
              width: width,
              shouldShowAudioIcon: shouldShowAudioIcon,
            )
        ],
      ),
    );
  }
}

class _ArticleImageOverlay extends StatelessWidget {
  const _ArticleImageOverlay({
    required this.article,
    required this.height,
    required this.width,
    required this.shouldShowAudioIcon,
    Key? key,
  }) : super(key: key);
  final MediaItemArticle article;
  final double? height;
  final double? width;
  final bool shouldShowAudioIcon;

  @override
  Widget build(BuildContext context) {
    final timeToRead = article.timeToRead;
    final hasImage = article.hasImage;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimens.m, AppDimens.xl, AppDimens.m, AppDimens.m),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasImage) ...[
                PublisherLogo.light(publisher: article.publisher),
                if (article.hasAudioVersion && shouldShowAudioIcon) AudioIconButton(article: article)
              ] else ...[
                PublisherLogo.dark(publisher: article.publisher),
                if (article.hasAudioVersion && shouldShowAudioIcon) AudioIconButton(article: article)
              ]
            ],
          ),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            maxLines: hasImage ? 4 : 5,
            markdown: article.title,
            highlightColor: hasImage ? AppColors.transparent : AppColors.limeGreen,
            baseTextStyle: AppTypography.h5BoldSmall.copyWith(
              height: hasImage ? 1.71 : 1.5,
              color: hasImage ? AppColors.white : AppColors.textPrimary,
              fontSize: context.isSmallDevice ? 12 : null,
            ),
          ),
          const Spacer(),
          if (timeToRead != null)
            Text(
              LocaleKeys.article_readMinutes.tr(args: [timeToRead.toString()]),
              style: AppTypography.systemText.copyWith(
                color: hasImage ? AppColors.white : AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
