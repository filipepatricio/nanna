import 'package:better_informed_mobile/domain/article/data/article.dart';
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
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/use_automatic_keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PremiumArticleReadView extends HookWidget {
  PremiumArticleReadView({
    required this.article,
    required this.articleController,
    required this.pageController,
    required this.cubit,
    required this.mainController,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  final Article article;
  final ScrollController articleController;
  final PageController pageController;
  final ScrollController mainController;
  final MediaItemCubit cubit;
  final double? readArticleProgress;

  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();

  bool get articleWithImage => article.metadata.hasImage;

  void calculateArticleContentOffset() {
    final globalContentOffset = _calculateGlobalOffset(_articleContentKey) ?? 0;
    final globalPageOffset = _calculateGlobalOffset(_articlePageKey) ?? 0;
    cubit.setupScrollData(globalContentOffset, globalPageOffset);
  }

  double? _calculateGlobalOffset(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return position?.dy;
  }

  bool _updateScrollPosition(
    ScrollNotification scrollInfo,
    ValueNotifier<bool> showTabBar,
    ValueNotifier<double> readProgress,
    ValueNotifier<double> dynamicListenButtonPosition,
    double fullHeight,
    bool showAudioButton,
    BuildContext context,
  ) {
    if (articleController.hasClients) {
      if (scrollInfo is ScrollUpdateNotification) {
        final newProgress = articleController.offset / articleController.position.maxScrollExtent;

        if ((scrollInfo.dragDetails?.primaryDelta ?? 0).abs() > 1 &&
            scrollInfo is! ScrollEndNotification &&
            (pageController.page ?? 0) >= 1) {
          showTabBar.value = (scrollInfo.dragDetails?.primaryDelta ?? 0) > 0;
        }

        readProgress.value = newProgress.isFinite ? newProgress : 0;

        dynamicListenButtonPosition.value = calculateAudioPlayButtonPositionOnSectionTransition(
          showAudioButton,
          showTabBar.value,
          readProgress.value,
          context,
        );
      }
      if (scrollInfo is ScrollEndNotification) {
        var readScrollOffset = articleController.offset - cubit.scrollData.contentOffset;
        if (readScrollOffset < 0) {
          readScrollOffset = fullHeight - (cubit.scrollData.contentOffset - articleController.offset);
        }
        if (scrollInfo.metrics.pixels == mainController.position.maxScrollExtent) {
          showTabBar.value = true;

          dynamicListenButtonPosition.value = calculateAudioPlayButtonPositionOnSectionTransition(
            showAudioButton,
            showTabBar.value,
            readProgress.value,
            context,
          );
        }

        cubit.updateScrollData(
          readScrollOffset,
          articleController.position.maxScrollExtent,
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);

    final gestureManager = useMemoized(
      () => MediaItemPageGestureManager(
        context: context,
        articleViewController: articleController,
        pageViewController: pageController,
        articleHasImage: articleWithImage,
        mainViewController: mainController,
      ),
      [articleWithImage],
    );
    final readProgress = useMemoized(() => ValueNotifier(0.0));
    final showTabBar = useState(false);
    final showAudioFloatingButton = useState(false);
    final dynamicListenPosition = useMemoized(
      () => ValueNotifier(
        calculateAudioPlayButtonPositionOnSectionTransition(
          showAudioFloatingButton.value,
          showTabBar.value,
          readProgress.value,
          context,
        ),
      ),
    );

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
          final page = pageController.page ?? 0.0;
          showAudioFloatingButton.value = page > 0.9 && !showTabBar.value;
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
            dynamicListenPosition,
            constraints.maxHeight,
            showAudioFloatingButton.value,
            context,
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
                  CustomScrollView(
                    controller: mainController,
                    physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                    slivers: [
                      SliverFillViewport(
                        delegate: SliverChildListDelegate(
                          [
                            _ArticleContentView(
                              article: article,
                              articleContentKey: _articleContentKey,
                              articleController: articleController,
                              cubit: cubit,
                              dynamicPosition: dynamicListenPosition,
                              readProgress: readProgress,
                            ),
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            ///Add additional content here
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InformedTabBar.floating(show: showTabBar.value),
            ],
          ),
        ),
      ),
    );
  }

  double calculateAudioPlayButtonPositionOnSectionTransition(
    bool showButton,
    bool showTabBar,
    double readProgress,
    BuildContext context,
  ) {
    if (showButton) {
      if (showTabBar) {
        if (readProgress == 1.0) {
          final positionLogicalPixels = mainController.position.pixels / MediaQuery.of(context).devicePixelRatio;
          final threshold = MediaQuery.of(context).viewPadding.bottom == 0
              ? (kBottomNavigationBarHeight / MediaQuery.of(context).devicePixelRatio)
              : MediaQuery.of(context).padding.bottom;

          if (positionLogicalPixels <= threshold) {
            final percentageValueOfPosition = positionLogicalPixels / threshold;
            final requiredPercentage = 1 - percentageValueOfPosition;
            final position = AppDimens.l +
                requiredPercentage * (kBottomNavigationBarHeight + MediaQuery.of(context).viewPadding.bottom);
            return position;
          } else {
            return AppDimens.l;
          }
        } else {
          return _bottomBarShownAudioButtonBottomPosition(context);
        }
      } else {
        return AppDimens.l;
      }
    } else {
      return -AppDimens.xxxc;
    }
  }
}

double _bottomBarShownAudioButtonBottomPosition(BuildContext context) =>
    AppDimens.l + (kBottomNavigationBarHeight + MediaQuery.of(context).viewPadding.bottom);

class _ArticleContentView extends HookWidget {
  const _ArticleContentView({
    required this.article,
    required this.readProgress,
    required this.dynamicPosition,
    required this.articleController,
    required this.cubit,
    required this.articleContentKey,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<double> readProgress;
  final ValueNotifier<double> dynamicPosition;
  final ScrollController articleController;
  final Article article;
  final MediaItemCubit cubit;
  final Key articleContentKey;

  @override
  Widget build(BuildContext context) {
    final footerHeight = useMemoized(
      () => MediaQuery.of(context).size.height / 3,
      [MediaQuery.of(context).size.height],
    );

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomScrollView(
                primary: false,
                physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                controller: articleController,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        ArticleContentView(
                          article: article,
                          cubit: cubit,
                          articleContentKey: articleContentKey,
                          scrollToPosition: () => _scrollToPosition(readProgress.value),
                        ),
                        if (article.metadata.credits.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppDimens.xl,
                              left: AppDimens.l,
                              right: AppDimens.l,
                            ),
                            child: _Credits(
                              credits: article.metadata.credits,
                            ),
                          ),
                          SizedBox(height: footerHeight),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _ArticleProgressBar(readProgress: readProgress),
          ],
        ),
        if (article.metadata.hasAudioVersion)
          _AnimatedAudioButton(
            dynamicPosition: dynamicPosition,
            readProgress: readProgress,
            article: article.metadata,
          ),
      ],
    );
  }

  void _scrollToPosition(double? readArticleProgress) {
    if (readArticleProgress != null && readArticleProgress != 1.0) {
      final scrollPosition = cubit.scrollData.contentOffset +
          ((articleController.position.maxScrollExtent - cubit.scrollData.contentOffset) * readArticleProgress);
      articleController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }
}

class _AnimatedAudioButton extends StatelessWidget {
  const _AnimatedAudioButton({
    required this.article,
    required this.readProgress,
    required this.dynamicPosition,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ValueNotifier<double> readProgress;
  final ValueNotifier<double> dynamicPosition;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dynamicPosition,
      builder: (BuildContext context, double value, Widget? child) {
        return AnimatedPositioned(
          right: AppDimens.l,
          bottom: value,
          curve: Curves.easeIn,
          duration: Duration(
            milliseconds:
                (value == _bottomBarShownAudioButtonBottomPosition(context) || value == AppDimens.l) ? 200 : 0,
          ),
          child: AudioFloatingControlButton(article: article),
        );
      },
    );
  }
}

class _ArticleProgressBar extends HookWidget {
  const _ArticleProgressBar({
    required this.readProgress,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<double> readProgress;

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
