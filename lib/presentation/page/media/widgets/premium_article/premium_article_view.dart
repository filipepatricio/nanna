import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_actions_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_cubit_provider.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_read_view.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PremiumArticleView extends HookWidget {
  const PremiumArticleView({
    required this.article,
    required this.content,
    required this.fromTopic,
    required this.modalController,
    required this.controller,
    required this.pageController,
    required this.cubit,
    required this.fullHeight,
    required this.snackbarController,
    required this.articleOutputMode,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ArticleContent content;
  final bool fromTopic;
  final ScrollController modalController;
  final ScrollController controller;
  final PageController pageController;
  final MediaItemCubit cubit;
  final double fullHeight;
  final double? readArticleProgress;
  final SnackbarController snackbarController;
  final ArticleOutputMode articleOutputMode;

  bool get articleWithImage => article.image != null;

  @override
  Widget build(BuildContext context) {
    final horizontalPageController = usePageController(initialPage: articleOutputMode.index);
    final articleOutputModeNotifier = useMemoized(
      () => ValueNotifier(articleOutputMode),
    );

    useEffect(
      () {
        final listener = () {
          switch (articleOutputModeNotifier.value) {
            case ArticleOutputMode.read:
              horizontalPageController.animateToPage(
                ArticleOutputMode.read.index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            case ArticleOutputMode.audio:
              horizontalPageController.animateToPage(
                ArticleOutputMode.audio.index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
          }
        };
        articleOutputModeNotifier.addListener(listener);
        return () => articleOutputModeNotifier.removeListener(listener);
      },
      [horizontalPageController, articleOutputModeNotifier],
    );

    return Scaffold(
      body: SnackbarParentView(
        controller: snackbarController,
        child: PremiumArticleAudioCubitProvider(
          article: article,
          audioCubitBuilder: (audioCubit) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                physics: const ClampingScrollPhysics(),
                controller: horizontalPageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (page) {
                  switch (page) {
                    case 0:
                      articleOutputModeNotifier.value = ArticleOutputMode.read;
                      break;
                    case 1:
                      articleOutputModeNotifier.value = ArticleOutputMode.audio;
                      break;
                  }
                },
                children: [
                  PremiumArticleReadView(
                    article: article,
                    content: content,
                    modalController: modalController,
                    controller: controller,
                    pageController: pageController,
                    snackbarController: snackbarController,
                    cubit: cubit,
                    fullHeight: fullHeight,
                    fromTopic: fromTopic,
                    readArticleProgress: readArticleProgress,
                    articleOutputModeNotifier: articleOutputModeNotifier,
                  ),
                  if (article.hasAudioVersion)
                    PremiumArticleAudioView(
                      article: article,
                      cubit: audioCubit,
                    ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PremiumArticleActionsBar(
                  article: article,
                  fullHeight: articleWithImage ? fullHeight : appBarHeight,
                  pageController: pageController,
                  snackbarController: snackbarController,
                  cubit: cubit,
                  articleOutputModeNotifier: articleOutputModeNotifier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
