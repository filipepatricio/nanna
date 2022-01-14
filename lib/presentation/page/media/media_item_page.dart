import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
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
import 'package:better_informed_mobile/presentation/page/media/pull_up_indicator_action/pull_up_indicator_action.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

typedef MediaItemNavigationCallback = void Function(int index);

const appBarHeight = kToolbarHeight + AppDimens.xl;
const _loadNextArticleIndicatorHeight = 150.0;

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
            /// As cupertino bottom sheet works on ScrollNotification instead of ScrollController itself it's the only way
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
                  idleMultiItems: (state) => _IdleContent(
                    article: state.header,
                    content: state.content,
                    hasNextArticle: state.hasNext,
                    multipleArticles: true,
                    modalController: modalController,
                    controller: scrollController,
                    pageController: pageController,
                    cubit: cubit,
                    fullHeight: constraints.maxHeight,
                    readArticleProgress: readArticleProgress,
                  ),
                  idleSingleItem: (state) => _IdleContent(
                    article: state.header,
                    content: state.content,
                    hasNextArticle: false,
                    multipleArticles: false,
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
  final bool hasNextArticle;
  final bool multipleArticles;
  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();
  final double fullHeight;
  final double? readArticleProgress;

  _IdleContent({
    required this.article,
    required this.content,
    required this.hasNextArticle,
    required this.multipleArticles,
    required this.modalController,
    required this.controller,
    required this.pageController,
    required this.cubit,
    required this.fullHeight,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  bool get articleWithImage => article.image != null;

  @override
  Widget build(BuildContext context) {
    final nextArticleLoaderFactor = useMemoized(() => ValueNotifier(0.0), [article]);
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
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        calculateArticleContentOffset();
      });
    }, []);

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(), (VerticalDragGestureRecognizer instance) {
          instance
            ..onStart = gestureManager.handleDragStart
            ..onUpdate = gestureManager.handleDragUpdate
            ..onEnd = gestureManager.handleDragEnd
            ..onCancel = gestureManager.handleDragCancel;
        })
      },
      behavior: HitTestBehavior.opaque,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            if (controller.hasClients) {
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
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              controller: pageController,
              scrollDirection: Axis.vertical,
              children: [
                if (articleWithImage)
                  ArticleImageView(
                    article: article,
                    controller: pageController,
                    fullHeight: fullHeight,
                  ),
                CustomScrollView(
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
                    if (hasNextArticle) ...[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppDimens.xxl),
                            child: ValueListenableBuilder(
                              valueListenable: nextArticleLoaderFactor,
                              builder: (BuildContext context, double value, Widget? child) {
                                final opacity = max(0.0, 1 - value * 2);
                                return FadeTransition(
                                  opacity: AlwaysStoppedAnimation(opacity),
                                  child: child,
                                );
                              },
                              child: const AnimatedPointerDown(arrowColor: AppColors.textPrimary),
                            ),
                          ),
                        ),
                      ),
                      SliverPullUpIndicatorAction(
                        builder: (context, factor) {
                          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                            nextArticleLoaderFactor.value = factor;
                          });
                          return _LoadingNextArticleIndicator(factor: factor);
                        },
                        fullExtentHeight: _loadNextArticleIndicatorHeight,
                        triggerExtent: _loadNextArticleIndicatorHeight,
                        triggerFunction: (completer) => cubit.loadNextArticle(completer),
                      ),
                    ] else if (multipleArticles)
                      const SliverToBoxAdapter(
                        child: _AllArticlesRead(),
                      ),
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

class _LoadingNextArticleIndicator extends StatelessWidget {
  final double factor;

  const _LoadingNextArticleIndicator({
    required this.factor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(factor),
      child: ScaleTransition(
        scale: AlwaysStoppedAnimation(factor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SvgPicture.asset(AppVectorGraphics.loadNextArticle),
            ),
            const SizedBox(height: AppDimens.s),
            Text(
              LocaleKeys.article_loadingNext.tr(),
              style: AppTypography.b1Regular.copyWith(height: 1.2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AllArticlesRead extends StatelessWidget {
  const _AllArticlesRead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          Center(
            child: SvgPicture.asset(AppVectorGraphics.noNextArticle),
          ),
          const SizedBox(height: AppDimens.s),
          Text(
            LocaleKeys.article_allArticlesRead.tr(),
            style: AppTypography.b1Regular.copyWith(height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.xl),
          FilledButton(
            text: LocaleKeys.article_goBackToTopic.tr(),
            fillColor: AppColors.textPrimary,
            textColor: AppColors.white,
            leading: const Icon(Icons.arrow_back_ios_new_rounded, size: AppDimens.m, color: AppColors.white),
            onTap: () => AutoRouter.of(context).pop(),
          ),
          const SizedBox(height: AppDimens.l),
        ],
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
