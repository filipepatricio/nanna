import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/no_connection_banner/no_connection_banner.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const articleTextScaleFactorSelectorButtonKey = Key('article_text_scale_factor_selector_button');

class ArticleAppBar extends HookWidget implements PreferredSizeWidget {
  const ArticleAppBar({
    required this.article,
    this.actionsBarColorModeNotifier,
    this.briefId,
    this.topicId,
    this.isConnected = true,
    this.shouldShowTitle = false,
    this.showTextScaleFactorSelector,
    this.openedFrom,
  });

  final MediaItemArticle article;
  final ValueNotifier<ArticleActionsBarColorMode>? actionsBarColorModeNotifier;
  final String? briefId;
  final String? topicId;
  final bool isConnected;
  final bool shouldShowTitle;
  final VoidCallback? showTextScaleFactorSelector;
  final String? openedFrom;

  bool get fromTopic => topicId != null;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (isConnected ? 0 : NoConnectionBanner.height),
      );

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.of(context).backgroundPrimary;
    final animationController = useAnimationController(duration: const Duration(milliseconds: 150));
    final backgroundColorAnimation = ColorTween(
      begin: article.category.color ?? backgroundColor,
      end: backgroundColor,
    ).chain(CurveTween(curve: Curves.easeIn)).animate(animationController);

    final foregroundColorAnimation = ColorTween(
      begin: AppColors.categoriesTextPrimary,
      end: AppColors.of(context).textPrimary,
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
      animation: backgroundColorAnimation,
      builder: (context, _) => ClipRect(
        child: InformedAppBar(
          isConnected: isConnected,
          backgroundColor: backgroundColorAnimation.value,
          leading: BackTextButton(
            color: foregroundColorAnimation.value,
            text: fromTopic ? context.l10n.topic_label : openedFrom ?? context.l10n.common_back,
          ),
          title: shouldShowTitle ? article.publisher.name : null,
          titleColor: foregroundColorAnimation.value,
          actions: [
            if (showTextScaleFactorSelector != null)
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  key: articleTextScaleFactorSelectorButtonKey,
                  onPressed: showTextScaleFactorSelector,
                  icon: InformedSvg(
                    AppVectorGraphics.text,
                    color: foregroundColorAnimation.value,
                  ),
                ),
              ),
            BookmarkButton.article(
              article: article,
              topicId: topicId,
              briefId: briefId,
              color: foregroundColorAnimation.value,
            ),
            Align(
              alignment: Alignment.center,
              child: ShareArticleButton(
                article: article,
                color: foregroundColorAnimation.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
