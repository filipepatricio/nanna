import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_read_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

enum ArticleActionsBarColorMode { custom, background }

class PremiumArticleView extends HookWidget {
  const PremiumArticleView({
    required this.article,
    required this.articleOutputMode,
    this.topicSlug,
    this.topicId,
    this.briefId,
    this.openedFrom,
    Key? key,
  }) : super(key: key);

  final Article article;
  final ArticleOutputMode articleOutputMode;
  final String? topicSlug;
  final String? topicId;
  final String? briefId;
  final String? openedFrom;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<PremiumArticleViewCubit>();
    final state = useCubitBuilder(cubit);
    final mainController = useScrollController(keepScrollOffset: true);
    final isScrolled = useValueNotifier(false);
    final actionsBarColorModeNotifier = useMemoized(
      () => ValueNotifier(
        articleOutputMode == ArticleOutputMode.read
            ? ArticleActionsBarColorMode.custom
            : ArticleActionsBarColorMode.background,
      ),
    );
    final snackbarController = useSnackbarController();

    useEffect(
      () {
        cubit.initialize(article, briefId, topicSlug, topicId);
      },
      [article],
    );

    void updateAppBar() {
      final scrolled = mainController.offset >= kToolbarHeight;
      isScrolled.value = scrolled;
      actionsBarColorModeNotifier.value =
          scrolled ? ArticleActionsBarColorMode.background : ArticleActionsBarColorMode.custom;
    }

    useEffect(
      () {
        mainController.addListener(updateAppBar);
        return () => mainController.removeListener(updateAppBar);
      },
      [mainController],
    );

    useCubitListener<PremiumArticleViewCubit, PremiumArticleViewState>(
      cubit,
      (cubit, state, context) => state.mapOrNull(
        freeArticlesWarning: (data) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: data.message,
              subMessage: context.l10n.subscription_snackbar_link,
              action: SnackbarAction(
                label: context.l10n.subscription_snackbar_action,
                callback: () => context.pushRoute(const SubscriptionPageRoute()),
              ),
              type: SnackbarMessageType.subscription,
            ),
          );
        },
      ),
    );

    return ScrollsToTop(
      onScrollsToTop: (_) => mainController.animateToStart(),
      child: ValueListenableBuilder<bool>(
        valueListenable: isScrolled,
        builder: (context, isScrolled, child) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: ArticleAppBar(
            article: article.metadata,
            briefId: briefId,
            topicId: topicId,
            openedFrom: openedFrom,
            shouldShowTitle: isScrolled,
            actionsBarColorModeNotifier: actionsBarColorModeNotifier,
            isConnected: context.watch<IsConnected>(),
            showTextScaleFactorSelector: state.mapOrNull(
              idle: (data) => data.showTextScaleFactorSelector
                  ? () => context.pushRoute(
                        ArticleTextScaleFactorSelectorPageRoute(
                          onChangeEnd: cubit.setPreferredArticleTextScaleFactor,
                        ),
                      )
                  : null,
            ),
          ),
          body: child,
        ),
        child: ScrollsToTop(
          onScrollsToTop: (_) => mainController.animateToStart(),
          child: PremiumArticleReadView(cubit: cubit, mainController: mainController, openedFrom: openedFrom),
        ),
      ),
    );
  }
}

void showFreeArticlesWarning(BuildContext context, SnackbarController snackbarController, String message) {}
