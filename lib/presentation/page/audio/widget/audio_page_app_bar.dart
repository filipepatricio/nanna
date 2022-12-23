part of '../audio_page.dart';

class _AudioPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AudioPageAppBar({
    required this.article,
    required this.isLight,
  });

  final MediaItemArticle article;
  final bool isLight;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final iconColor = (isLight ? AppColors.dark : AppColors.light).iconPrimary;

    return AppBar(
      systemOverlayStyle: isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      backgroundColor: AppColors.transparent,
      leading: InformedCloseButton(color: iconColor),
      actions: [
        BookmarkButton.article(
          article: article,
          color: iconColor,
        ),
        const SizedBox(width: AppDimens.m),
        Align(
          alignment: Alignment.center,
          child: ShareArticleButton(
            article: article,
            buttonBuilder: (context) => SvgPicture.asset(
              AppVectorGraphics.share,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.ml),
      ],
    );
  }
}
