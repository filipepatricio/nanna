import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article_custom_vertical_drag_manager.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_data.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

typedef MediaItemNavigationCallback = void Function(int index);

const appBarHeight = kToolbarHeight + AppDimens.xl;

class MediaItemPage extends HookWidget {
  final double? readArticleProgress;
  final int index;
  final MediaItemArticle? singleArticle;
  final MediaItemNavigationCallback? navigationCallback;
  final Topic? topic;

  MediaItemPage({
    required MediaItemPageData pageData,
    Key? key,
  })  : index = _getIndex(pageData),
        singleArticle = _getSingleArticle(pageData),
        navigationCallback = pageData.navigationCallback,
        readArticleProgress = pageData.readArticleProgress,
        topic = _getTopic(pageData),
        super(key: key);

  static Topic? _getTopic(MediaItemPageData pageData) => pageData.map(
        singleItem: (data) => null,
        multipleItems: (data) => data.topic,
      );

  static int _getIndex(MediaItemPageData pageData) => pageData.map(
        singleItem: (data) => 0,
        multipleItems: (data) => data.index,
      );

  static MediaItemArticle? _getSingleArticle(MediaItemPageData pageData) => pageData.map(
        singleItem: (data) => data.article,
        multipleItems: (data) => null,
      );

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MediaItemCubit>();
    final state = useCubitBuilder(cubit);

    final modalController = useMemoized(
      () => ModalScrollController.of(context) ?? ScrollController(keepScrollOffset: true),
    );
    final scrollController = useMemoized(
      () => ScrollController(keepScrollOffset: true),
    );
    final pageController = usePageController();

    useCubitListener<MediaItemCubit, MediaItemState>(cubit, (cubit, state, context) {
      state.mapOrNull(nextPageLoaded: (state) {
        navigationCallback?.call(state.index);
        scrollController.jumpTo(0.0);
        pageController.jumpToPage(0);
      });
    });

    useEffect(() {
      cubit.initialize(index, singleArticle, topic);
    }, [cubit]);

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            /// This invisible scroll view is a way around to make cupertino bottom sheet work with pull down gesture
            ///
            /// As cupertino bottom sheet works on ScrollNotification
            /// instead of ScrollController itself it's the only way
            /// to make sure it will work - at least only way I found
            SizedBox(
              height: 0,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                controller: modalController,
                child: const SizedBox(
                  height: 0,
                ),
              ),
            ),
            Expanded(
              child: _AnimatedSwitcher(
                child: state.maybeMap(
                  loading: (state) => const _LoadingContent(),
                  idle: (state) => _IdleContent(
                    article: state.header,
                    content: state.content,
                    modalController: modalController,
                    controller: scrollController,
                    pageController: pageController,
                    cubit: cubit,
                    fullHeight: constraints.maxHeight,
                    readArticleProgress: readArticleProgress,
                  ),
                  error: (state) => _ErrorContent(article: state.article),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l, top: AppDimens.s),
          child: IconButton(
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textPrimary,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            onPressed: () => context.popRoute(),
          ),
        ),
        const Expanded(
          child: Center(
            child: Loader(color: AppColors.darkGrey),
          ),
        ),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final MediaItemArticle article;

  const _ErrorContent({
    required this.article,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l, top: AppDimens.m),
          child: IconButton(
            icon: const Icon(Icons.close_rounded),
            color: AppColors.black,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            onPressed: () => context.popRoute(),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimens.l),
            SvgPicture.asset(AppVectorGraphics.articleError),
            const SizedBox(height: AppDimens.m),
            Text(
              LocaleKeys.todaysTopics_oops.tr(),
              style: AppTypography.h3bold,
              textAlign: TextAlign.center,
            ),
            Text(
              LocaleKeys.article_loadError.tr(),
              style: AppTypography.h3Normal,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.xl),
            OpenWebButton(
              url: article.sourceUrl,
              buttonLabel: LocaleKeys.article_openSourceUrl.tr(),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.xxxl + AppDimens.l),
      ],
    );
  }
}

class _IdleContent extends HookWidget {
  final MediaItemArticle article;
  final ArticleContent content;
  final MediaItemCubit cubit;
  final ScrollController modalController;
  final ScrollController controller;
  final PageController pageController;
  final double fullHeight;
  final double? readArticleProgress;

  const _IdleContent({
    required this.article,
    required this.content,
    required this.modalController,
    required this.controller,
    required this.pageController,
    required this.cubit,
    required this.fullHeight,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (article.type == ArticleType.freemium) {
      return _FreeArticleView(
        article: article,
      );
    }

    return _PremiumArticleView(
      article: article,
      content: content,
      modalController: modalController,
      controller: controller,
      pageController: pageController,
      cubit: cubit,
      fullHeight: fullHeight,
      readArticleProgress: readArticleProgress,
    );
  }
}

class _PremiumArticleView extends HookWidget {
  _PremiumArticleView({
    required this.article,
    required this.content,
    required this.modalController,
    required this.controller,
    required this.pageController,
    required this.cubit,
    required this.fullHeight,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ArticleContent content;
  final ScrollController modalController;
  final ScrollController controller;
  final PageController pageController;
  final MediaItemCubit cubit;
  final double fullHeight;
  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();
  final double? readArticleProgress;

  bool get articleWithImage => article.image != null;

  @override
  Widget build(BuildContext context) {
    final showBackToTopicButton = useState(false);
    final footerHeight = MediaQuery.of(context).size.height / 3;
    final readProgress = useMemoized(() => ValueNotifier(0.0));
    final gestureManager = useMemoized(
      () => ArticleCustomVerticalDragManager(
        modalController: modalController,
        generalViewController: controller,
        pageViewController: pageController,
        articleHasImage: articleWithImage,
      ),
      [articleWithImage],
    );

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) => calculateArticleContentOffset());
    }, []);

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
          (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = gestureManager.handleDragStart
              ..onUpdate = gestureManager.handleDragUpdate
              ..onEnd = gestureManager.handleDragEnd
              ..onCancel = gestureManager.handleDragCancel;
          },
        )
      },
      behavior: HitTestBehavior.opaque,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (controller.hasClients) {
            if (notification is ScrollUpdateNotification) {
              final newProgress = controller.offset / controller.position.maxScrollExtent;
              showBackToTopicButton.value = newProgress < readProgress.value;
              readProgress.value = newProgress;
            }
            if (notification is ScrollEndNotification) {
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
        },
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
                                    scrollToPosition: () => scrollToPosition(readArticleProgress),
                                  ),
                                ],
                              ),
                            ),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _ActionsBar(
                article: article,
                fullHeight: articleWithImage ? fullHeight : appBarHeight,
                controller: pageController,
              ),
            ),
            _BackToTopicButton(showButton: showBackToTopicButton)
          ],
        ),
      ),
    );
  }

  void calculateArticleContentOffset() {
    final globalContentOffset = _calculateGlobalOffset(_articleContentKey) ?? 0;
    final globalPageOffset = _calculateGlobalOffset(_articlePageKey) ?? 0;
    cubit.setupScrollData(globalContentOffset, globalPageOffset);
  }

  void scrollToPosition(double? readArticleProgress) {
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
}

class _FreeArticleView extends HookWidget {
  const _FreeArticleView({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final showBackToTopicButton = useState(false);
    final scrollPosition = useMemoized(() => ValueNotifier(0.0));

    final webViewOptions = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(useHybridComposition: true),
      ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
    );

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.textPrimary,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppDimens.l, top: AppDimens.s),
          child: IconButton(
            icon: const Icon(Icons.close_rounded),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            onPressed: () => context.popRoute(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.l, top: AppDimens.s),
            child: ShareArticleButton(
              article: article,
              buttonBuilder: (context) => SvgPicture.asset(AppVectorGraphics.share),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InAppWebView(
            initialOptions: webViewOptions,
            initialUrlRequest: URLRequest(url: Uri.parse(article.sourceUrl)),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory(() => EagerGestureRecognizer()),
            },
            onScrollChanged: (controller, _, y) {
              if (y > scrollPosition.value) {
                scrollPosition.value = y.toDouble();
                showBackToTopicButton.value = false;
                return;
              }

              if (y < scrollPosition.value) {
                scrollPosition.value = y.toDouble();
                showBackToTopicButton.value = true;
              }
            },
            onOverScrolled: (controller, x, y, clampedX, clampedY) {
              if (clampedY && y > 0) {
                showBackToTopicButton.value = true;
              }
            },
          ),
          _BackToTopicButton(showButton: showBackToTopicButton),
        ],
      ),
    );
  }
}

class _BackToTopicButton extends StatelessWidget {
  const _BackToTopicButton({
    required this.showButton,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> showButton;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: showButton.value ? AppDimens.l : -AppDimens.c,
      curve: Curves.elasticInOut,
      duration: const Duration(milliseconds: 500),
      child: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.s)),
        onPressed: () => context.popRoute(),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        label: Text(
          LocaleKeys.article_goBackToTopic.tr(),
          style: AppTypography.h3Bold16.copyWith(height: 1.0, color: AppColors.white),
        ),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppDimens.backArrowSize,
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
                    minHeight: 7,
                  );
                })));
  }
}

class _ActionsBar extends HookWidget {
  const _ActionsBar({
    required this.article,
    required this.fullHeight,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final double fullHeight;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    final hasImage = useMemoized(() => article.image != null, [article]);

    final backgroundColor = useMemoized(
      () => ValueNotifier(hasImage ? AppColors.transparent : AppColors.background),
      [hasImage],
    );

    final buttonColor = useMemoized(
      () => ValueNotifier(hasImage ? AppColors.white : AppColors.textPrimary),
      [hasImage],
    );

    useEffect(
      () {
        if (!hasImage) return () {};

        final buttonTween = ColorTween(begin: AppColors.white, end: AppColors.textPrimary);

        final listener = () {
          final page = controller.page ?? 0.0;

          backgroundColor.value = page == 1.0 ? AppColors.background : AppColors.transparent;

          final buttonAnimValue = AlwaysStoppedAnimation(min(1.0, page));
          buttonColor.value = buttonTween.evaluate(buttonAnimValue) ?? AppColors.white;
        };

        controller.addListener(listener);
        return () => controller.removeListener(listener);
      },
      [controller, article],
    );

    return ValueListenableBuilder(
      valueListenable: backgroundColor,
      builder: (BuildContext context, Color value, Widget? child) {
        return Container(
          color: value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l) + const EdgeInsets.only(top: AppDimens.s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
              valueListenable: buttonColor,
              builder: (BuildContext context, Color value, Widget? child) {
                return IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: value,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  onPressed: () => context.popRoute(),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
              child: ShareArticleButton(
                article: article,
                buttonBuilder: (context) => ValueListenableBuilder(
                  valueListenable: buttonColor,
                  builder: (BuildContext context, Color value, Widget? child) {
                    return SvgPicture.asset(
                      AppVectorGraphics.share,
                      color: value,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSwitcher extends StatelessWidget {
  final Widget child;

  const _AnimatedSwitcher({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsTest
        ? child
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: child,
          );
  }
}
