import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image_view.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_gesture_manager.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/informed_tab_bar.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/use_automatic_keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PremiumArticleReadView extends HookWidget {
  PremiumArticleReadView({
    required this.article,
    required this.controller,
    required this.pageController,
    required this.snackbarController,
    required this.cubit,
    required this.fromTopic,
    this.readArticleProgress,
    this.articleOutputModeNotifier,
    Key? key,
  }) : super(key: key);

  final Article article;
  final ScrollController controller;
  final PageController pageController;
  final SnackbarController snackbarController;
  final MediaItemCubit cubit;
  final bool fromTopic;
  final double? readArticleProgress;
  final ValueNotifier<ArticleOutputMode>? articleOutputModeNotifier;

  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();

  bool get articleWithImage => article.metadata.hasImage;

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
    double fullHeight,
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
        generalViewController: controller,
        pageViewController: pageController,
        articleHasImage: articleWithImage,
      ),
      [articleWithImage],
    );
    final readProgress = useMemoized(() => ValueNotifier(0.0));
    final showTabBar = useState(false);
    final showAudioFloatingButton = useState(false);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => calculateArticleContentOffset(),
        );
      },
      [],
    );

    useEffect(
      () {
        void listener() {
          showAudioFloatingButton.value = !showTabBar.value;
        }

        showTabBar.addListener(listener);
        return () => showTabBar.removeListener(listener);
      },
      [showAudioFloatingButton, showTabBar],
    );

    useEffect(
      () {
        void listener() {
          final page = pageController.page ?? 0.0;
          showAudioFloatingButton.value = page > 0.5 && !showTabBar.value;
        }

        pageController.addListener(listener);
        return () => pageController.removeListener(listener);
      },
      [showAudioFloatingButton, pageController],
    );

    return RawGestureDetector(
      gestures: Map<Type, GestureRecognizerFactory>.fromEntries(
        [gestureManager.dragGestureRecognizer, gestureManager.tapGestureRecognizer],
      ),
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(
        builder: (context, constraints) => NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) => _updateScrollPosition(
            scrollInfo,
            showTabBar,
            readProgress,
            constraints.maxHeight,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                controller: pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (page) {
                  showTabBar.value = false;
                },
                children: [
                  if (articleWithImage)
                    ArticleImageView(
                      article: article.metadata,
                      controller: pageController,
                      fullHeight: constraints.maxHeight,
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
                                      cubit: cubit,
                                      controller: controller,
                                      articleContentKey: _articleContentKey,
                                      scrollToPosition: () => _scrollToPosition(readArticleProgress),
                                    ),
                                  ],
                                ),
                              ),
                              if (article.metadata.credits.isNotEmpty) ...[
                                SliverPadding(
                                  padding: const EdgeInsets.only(
                                    top: AppDimens.xl,
                                    left: AppDimens.l,
                                    right: AppDimens.l,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: _Credits(
                                      credits: article.metadata.credits,
                                    ),
                                  ),
                                ),
                              ],
                              SliverToBoxAdapter(
                                child: SizedBox(height: footerHeight),
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
              InformedTabBar.floating(show: showTabBar.value),
              _AnimatedAudioButton(
                article: article.metadata,
                showButton: showAudioFloatingButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedAudioButton extends StatelessWidget {
  const _AnimatedAudioButton({
    required this.article,
    required this.showButton,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ValueNotifier<bool> showButton;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      right: AppDimens.l,
      bottom: showButton.value && article.hasAudioVersion ? AppDimens.l : -AppDimens.xxxc,
      curve: Curves.elasticInOut,
      duration: const Duration(milliseconds: 500),
      child: AudioFloatingControlButton(article: article),
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

class _Credits extends StatelessWidget {
  const _Credits({
    required this.credits,
    Key? key,
  }) : super(key: key);

  final String credits;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: credits,
      styleSheet: MarkdownStyleSheet(
        p: AppTypography.articleTextRegular.copyWith(
          color: AppColors.textGrey,
          fontStyle: FontStyle.italic,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          openInAppBrowser(href);
        }
      },
    );
  }
}
