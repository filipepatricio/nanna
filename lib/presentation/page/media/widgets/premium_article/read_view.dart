import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image_view.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_gesture_manager.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/back_to_topic_button.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/credits.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/use_automatic_keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReadView extends HookWidget {
  ReadView({
    required this.article,
    required this.content,
    required this.modalController,
    required this.controller,
    required this.pageController,
    required this.snackbarController,
    required this.cubit,
    required this.fullHeight,
    required this.fromTopic,
    this.readArticleProgress,
    this.articleOutputMode,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ArticleContent content;
  final ScrollController modalController;
  final ScrollController controller;
  final PageController pageController;
  final SnackbarController snackbarController;
  final MediaItemCubit cubit;
  final double fullHeight;
  final bool fromTopic;
  final double? readArticleProgress;
  final ValueNotifier<ArticleOutputMode>? articleOutputMode;

  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();

  bool get articleWithImage => article.image != null;

  void calculateArticleContentOffset() {
    final globalContentOffset = _calculateGlobalOffset(_articleContentKey) ?? 0;
    final globalPageOffset = _calculateGlobalOffset(_articlePageKey) ?? 0;
    cubit.setupScrollData(globalContentOffset, globalPageOffset);
  }

  void _scrollToPosition(double? readArticleProgress) {
    if (readArticleProgress != null && readArticleProgress != 1.0) {
      final scrollPosition = cubit.scrollData.contentOffset +
          ((controller.position.maxScrollExtent - cubit.scrollData.contentOffset) * readArticleProgress);
      controller.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  double? _calculateGlobalOffset(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return position?.dy;
  }

  bool _updateScrollPosition(
    ScrollNotification scrollInfo,
    ValueNotifier<bool> showBackToTopicButton,
    ValueNotifier<double> readProgress,
  ) {
    if (controller.hasClients) {
      if (scrollInfo is ScrollUpdateNotification) {
        final newProgress = controller.offset / controller.position.maxScrollExtent;
        showBackToTopicButton.value = newProgress < readProgress.value;
        readProgress.value = newProgress.isFinite ? newProgress : 0;
      }
      if (scrollInfo is ScrollEndNotification) {
        var readScrollOffset = controller.offset - cubit.scrollData.contentOffset;
        if (readScrollOffset < 0) {
          readScrollOffset = fullHeight - (cubit.scrollData.contentOffset - controller.offset);
        }

        cubit.updateScrollData(
          readScrollOffset,
          controller.position.maxScrollExtent,
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);
    final footerHeight = MediaQuery.of(context).size.height / 3;

    final gestureManager = useMemoized(
      () => MediaItemPageGestureManager(
        context: context,
        modalController: modalController,
        generalViewController: controller,
        pageViewController: pageController,
        articleHasImage: articleWithImage,
      ),
      [articleWithImage],
    );
    final readProgress = useMemoized(() => ValueNotifier(0.0));
    final showBackToTopicButton = useState(false);

    useEffect(
      () {
        WidgetsBinding.instance?.addPostFrameCallback((_) => calculateArticleContentOffset());
      },
      [],
    );

    return RawGestureDetector(
      gestures: Map<Type, GestureRecognizerFactory>.fromEntries(
        [gestureManager.dragGestureRecognizer, gestureManager.tapGestureRecognizer],
      ),
      behavior: HitTestBehavior.opaque,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) => _updateScrollPosition(scrollInfo, showBackToTopicButton, readProgress),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              controller: pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (page) {
                showBackToTopicButton.value = false;
              },
              children: [
                if (articleWithImage)
                  ArticleImageView(
                    article: article,
                    controller: pageController,
                    fullHeight: fullHeight,
                  ),
                Row(
                  children: [
                    Expanded(
                      child: NoScrollGlow(
                        child: CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(
                            parent: BottomBouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                          ),
                          controller: controller,
                          slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  ArticleContentView(
                                    article: article,
                                    content: content,
                                    cubit: cubit,
                                    controller: controller,
                                    articleContentKey: _articleContentKey,
                                    scrollToPosition: () => _scrollToPosition(readArticleProgress),
                                  ),
                                ],
                              ),
                            ),
                            if (article.credits.isNotEmpty) ...[
                              SliverPadding(
                                padding: const EdgeInsets.only(
                                  top: AppDimens.xl,
                                  left: AppDimens.l,
                                  right: AppDimens.l,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: Credits(
                                    article: article,
                                  ),
                                ),
                              ),
                            ],
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: footerHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _ArticleProgressBar(readProgress: readProgress),
                  ],
                ),
              ],
            ),
            BackToTopicButton(
              showButton: showBackToTopicButton,
              fromTopic: fromTopic,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleProgressBar extends HookWidget {
  final ValueNotifier<double> readProgress;

  const _ArticleProgressBar({
    required this.readProgress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: RotatedBox(
        quarterTurns: 1,
        child: ValueListenableBuilder(
          valueListenable: readProgress,
          builder: (BuildContext context, double value, Widget? child) {
            return LinearProgressIndicator(
              value: readProgress.value,
              backgroundColor: AppColors.transparent,
              valueColor: const AlwaysStoppedAnimation(AppColors.limeGreenVivid),
              minHeight: 6,
            );
          },
        ),
      ),
    );
  }
}
