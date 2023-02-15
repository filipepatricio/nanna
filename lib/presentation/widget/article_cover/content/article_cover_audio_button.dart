part of '../article_cover.dart';

const _iconHeightImagePercentage = 0.8;

class _ArticleCoverAudioButton extends HookWidget {
  const _ArticleCoverAudioButton({
    required this.article,
    this.height = AppDimens.xl,
  });

  final MediaItemArticle article;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AudioControlButton(
      article: article,
      elevation: 0,
      backgroundColor: AppColors.of(context).backgroundSecondary,
      imageHeight: height * _iconHeightImagePercentage,
      progressSize: height,
      dimension: height,
    );
  }
}
