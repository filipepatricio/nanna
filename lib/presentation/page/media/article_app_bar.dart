import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_cupertino_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class ArticleAppBar extends HookWidget implements PreferredSizeWidget {
  const ArticleAppBar({
    required this.article,
    this.actionsBarColorModeNotifier,
    this.briefId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ValueNotifier<ArticleActionsBarColorMode>? actionsBarColorModeNotifier;
  final String? briefId;
  final String? topicId;

  bool get fromTopic => topicId != null;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 150));
    final animation = ColorTween(
      begin: article.hasImage ? (article.category.color ?? AppColors.background) : AppColors.background,
      end: AppColors.background95,
    ).chain(CurveTween(curve: Curves.easeIn)).animate(animationController);

    useEffect(
      () {
        if (actionsBarColorModeNotifier?.value == ArticleActionsBarColorMode.background) {
          animationController.animateTo(1, duration: Duration.zero);
        }

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
      builder: (context, bookmark) => ClipRect(
        child: InformedCupertinoAppBar(
          backgroundColor: animation.value,
          leading: BackTextButton(
            text: fromTopic ? LocaleKeys.topic_label.tr() : LocaleKeys.common_back.tr(),
          ),
          actions: [
            bookmark!,
            const SizedBox(width: AppDimens.m),
            Align(
              alignment: Alignment.center,
              child: ShareArticleButton(
                article: article,
                buttonBuilder: (context) => SvgPicture.asset(AppVectorGraphics.share),
              ),
            ),
            const SizedBox(width: AppDimens.ml),
          ],
        ),
      ),
      child: BookmarkButton.article(
        article: article,
        topicId: topicId,
        briefId: briefId,
        color: AppColors.charcoal,
      ),
    );
  }
}
