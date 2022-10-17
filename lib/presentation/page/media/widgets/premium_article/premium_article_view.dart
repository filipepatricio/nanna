import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_cubit_provider.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_read_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

enum ArticleActionsBarColorMode { custom, background }

class PremiumArticleView extends HookWidget {
  const PremiumArticleView({
    required this.article,
    required this.snackbarController,
    required this.articleOutputMode,
    this.topicSlug,
    this.topicId,
    this.briefId,
    Key? key,
  }) : super(key: key);

  final Article article;
  final SnackbarController snackbarController;
  final ArticleOutputMode articleOutputMode;
  final String? topicSlug;
  final String? topicId;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<PremiumArticleViewCubit>();
    final state = useCubitBuilder(cubit);
    final horizontalPageController = usePageController(initialPage: articleOutputMode.index);
    final articleOutputModeNotifier = useMemoized(() => ValueNotifier(articleOutputMode));
    final controller = useMemoized(() => ScrollController(keepScrollOffset: true));
    final mainController = useScrollController(keepScrollOffset: true);
    final actionsBarColorModeNotifier = useMemoized(
      () => ValueNotifier(
        articleOutputMode == ArticleOutputMode.read
            ? ArticleActionsBarColorMode.custom
            : ArticleActionsBarColorMode.background,
      ),
    );

    useEffect(
      () {
        cubit.initialize(article, briefId, topicSlug, topicId);
      },
      [horizontalPageController, articleOutputModeNotifier, article],
    );

    useCubitListener<PremiumArticleViewCubit, PremiumArticleViewState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          freeArticlesWarning: (data) => snackbarController.showMessage(
            SnackbarMessage.custom(
              message: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    data.message,
                    maxLines: 2,
                    style: AppTypography.b2Regular.copyWith(color: AppColors.charcoal),
                  ),
                  GestureDetector(
                    onTap: () => context.pushRoute(const SubscriptionPageRoute()),
                    child: AutoSizeText(
                      LocaleKeys.subscription_snackbar_link.tr(),
                      maxLines: 1,
                      style: AppTypography.b2Bold.copyWith(
                        color: AppColors.charcoal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              type: SnackbarMessageType.informative,
            ),
          ),
        );
      },
    );

    final showAudioMode = useMemoized(
      () => state.maybeMap(
        idle: (state) => state.article.metadata.hasAudioVersion && state.article.metadata.availableInSubscription,
        orElse: () => false,
      ),
      [state],
    );

    return Scaffold(
      appBar: ArticleAppBar(
        article: article.metadata,
        snackbarController: snackbarController,
        briefId: briefId,
        topicId: topicId,
        actionsBarColorModeNotifier: actionsBarColorModeNotifier,
        onBackPressed: () => context.popRoute(cubit.articleProgress),
      ),
      body: ScrollsToTop(
        onScrollsToTop: (_) => controller.animateToStart(),
        child: SnackbarParentView(
          controller: snackbarController,
          child: PremiumArticleAudioCubitProvider(
            article: article.metadata,
            audioCubitBuilder: (audioCubit) => Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView(
                  physics: state.scrollPhysics,
                  controller: horizontalPageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (page) {
                    switch (page) {
                      case 0:
                        articleOutputModeNotifier.value = ArticleOutputMode.read;
                        actionsBarColorModeNotifier.value = ArticleActionsBarColorMode.custom;
                        break;
                      case 1:
                        articleOutputModeNotifier.value = ArticleOutputMode.audio;
                        actionsBarColorModeNotifier.value = ArticleActionsBarColorMode.background;
                        break;
                    }
                  },
                  children: [
                    state.maybeMap(
                      idle: (_) => PremiumArticleReadView(
                        articleController: controller,
                        cubit: cubit,
                        mainController: mainController,
                        snackbarController: snackbarController,
                        actionsBarColorModeNotifier: actionsBarColorModeNotifier,
                      ),
                      orElse: Container.new,
                    ),
                    if (showAudioMode)
                      PremiumArticleAudioView(
                        article: article,
                        cubit: audioCubit,
                        enablePageSwipe: cubit.enablePageSwipe,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
