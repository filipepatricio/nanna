part of '../audio_page.dart';

class _AudioPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AudioPageAppBar({
    required this.article,
    required this.isLight,
  }) : iconsColor = isLight ? AppColors.white : AppColors.textPrimary;

  final MediaItemArticle article;
  final bool isLight;
  final Color iconsColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      backgroundColor: AppColors.transparent,
      leading: InformedCloseButton(color: iconsColor),
      actions: [
        BookmarkButton.article(
          article: article,
          color: iconsColor,
        ),
        const SizedBox(width: AppDimens.m),
        Align(
          alignment: Alignment.center,
          child: ShareArticleButton(
            article: article,
            buttonBuilder: (context) => SvgPicture.asset(
              AppVectorGraphics.share,
              color: iconsColor,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.ml),
      ],
    );
  }
}
