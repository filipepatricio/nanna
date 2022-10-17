import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class ArticleAppBar extends HookWidget implements PreferredSizeWidget {
  const ArticleAppBar({
    required this.article,
    required this.snackbarController,
    required this.onBackPressed,
    this.actionsBarColorModeNotifier,
    this.briefId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final SnackbarController snackbarController;
  final ValueNotifier<ArticleActionsBarColorMode>? actionsBarColorModeNotifier;
  final VoidCallback onBackPressed;
  final String? briefId;
  final String? topicId;

  bool get fromTopic => topicId != null;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 200));
    final animation = ColorTween(
      begin: article.hasImage ? (article.category?.color ?? AppColors.background) : AppColors.background,
      end: AppColors.background,
    ).chain(CurveTween(curve: Curves.easeIn)).animate(animationController);

    useEffect(
      () {
        void listener() {
          if (actionsBarColorModeNotifier?.value == ArticleActionsBarColorMode.custom) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        }

        actionsBarColorModeNotifier?.addListener(listener);
        return () => actionsBarColorModeNotifier?.removeListener(listener);
      },
      [actionsBarColorModeNotifier],
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, bookmarkButton) => AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: animation.value,
        leading: TextButton.icon(
          label: fromTopic
              ? Text(
                  LocaleKeys.article_topicOverview.tr(),
                  style: AppTypography.subH1Medium.copyWith(color: AppColors.textPrimary),
                )
              : const SizedBox.shrink(),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.only(right: fromTopic ? AppDimens.s : AppDimens.zero),
            ),
            foregroundColor: MaterialStateProperty.all(AppColors.textPrimary),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: AppDimens.backArrowSize,
          ),
          onPressed: onBackPressed,
        ),
        actions: [
          bookmarkButton!,
          const SizedBox(width: AppDimens.m),
          Align(
            alignment: Alignment.center,
            child: ShareArticleButton(
              article: article,
              snackbarController: snackbarController,
              buttonBuilder: (context) => SvgPicture.asset(AppVectorGraphics.share),
            ),
          ),
          const SizedBox(width: AppDimens.ml),
        ],
      ),
      child: BookmarkButton.article(
        article: article,
        topicId: topicId,
        briefId: briefId,
        color: AppColors.charcoal,
        snackbarController: snackbarController,
      ),
    );
  }
}
