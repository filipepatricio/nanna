import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image_view.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_data.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_state.dart';
import 'package:better_informed_mobile/presentation/page/media/pull_up_indicator_action/pull_up_indicator_action.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
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

double articleViewFullHeight(BuildContext context) => MediaQuery.of(context).size.height * 0.95;

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

    final scrollController = useMemoized(
      () => ModalScrollController.of(context) ?? ScrollController(keepScrollOffset: true),
    );

    useCubitListener<MediaItemCubit, MediaItemState>(cubit, (cubit, state, context) {
      state.mapOrNull(nextPageLoaded: (state) {
        navigationCallback?.call(state.index);
        scrollController.jumpTo(0.0);
      });
    });

    useEffect(() {
      cubit.initialize(index, singleArticle, topic);
    }, [cubit]);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: state.maybeMap(
          loading: (state) => const _LoadingContent(),
          idleMultiItems: (state) => _IdleContent(
            article: state.header,
            content: state.content,
            hasNextArticle: state.hasNext,
            multipleArticles: true,
            controller: scrollController,
            cubit: cubit,
            readArticleProgress: readArticleProgress,
          ),
          idleSingleItem: (state) => _IdleContent(
            article: state.header,
            content: state.content,
            hasNextArticle: false,
            multipleArticles: false,
            controller: scrollController,
            cubit: cubit,
            readArticleProgress: readArticleProgress,
          ),
          error: (state) => _ErrorContent(article: state.article),
          orElse: () => const SizedBox(),
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
    return const Center(child: Loader());
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
              LocaleKeys.dailyBrief_oops.tr(),
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
  final ScrollController controller;
  final bool hasNextArticle;
  final bool multipleArticles;
  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();
  final double? readArticleProgress;

  _IdleContent({
    required this.article,
    required this.content,
    required this.hasNextArticle,
    required this.multipleArticles,
    required this.controller,
    required this.cubit,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  bool get articleWithImage => article.image != null;

  @override
  Widget build(BuildContext context) {
    final fullHeight = articleViewFullHeight(context);
    final halfHeight = fullHeight / 2;
    final backgroundScrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        calculateArticleContentOffset();
      });
    }, []);

    useEffect(() {
      final scrollBackground = () {
        final quarterHeight = halfHeight / 2;
        final threeQuartersHeight = quarterHeight * 3;
        if (controller.hasClients && controller.offset >= 0) {
          backgroundScrollController.jumpTo(controller.offset > threeQuartersHeight
              ? controller.offset - (threeQuartersHeight / 2)
              : controller.offset / 2);
        }
      };

      if (articleWithImage) controller.addListener(scrollBackground);
      return () => controller.removeListener(scrollBackground);
    }, [controller, backgroundScrollController, article]);

    return LayoutBuilder(
      builder: (context, constrains) => NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            var readScrollOffset = controller.offset - cubit.scrollData.contentOffset;
            if (readScrollOffset < 0) {
              readScrollOffset = fullHeight - (cubit.scrollData.contentOffset - controller.offset);
            }

            cubit.updateScrollData(
              readScrollOffset,
              controller.position.maxScrollExtent,
            );
          }
          return false;
        },
        child: Stack(
          children: [
            //Article Header
            if (articleWithImage)
              CustomScrollView(
                physics: const BottomBouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: backgroundScrollController,
                key: _articlePageKey,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    expandedHeight: fullHeight,
                    collapsedHeight: 0,
                    toolbarHeight: 0,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    flexibleSpace: ArticleImageView(
                      article: article,
                      controller: controller,
                    ),
                  ),
                  const SliverFillRemaining(),
                ],
              ),
            //Article Content
            CustomScrollView(
              physics: const BottomBouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: controller,
              slivers: [
                _ActionsBar(
                  article: article,
                  fullHeight: articleWithImage ? fullHeight : appBarHeight,
                  controller: controller,
                ),
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
                if (hasNextArticle)
                  SliverPullUpIndicatorAction(
                    builder: (context, factor) => _LoadingNextArticleIndicator(factor: factor),
                    fullExtentHeight: _loadNextArticleIndicatorHeight,
                    triggerExtent: _loadNextArticleIndicatorHeight,
                    triggerFunction: (completer) => cubit.loadNextArticle(completer),
                  )
                else if (multipleArticles)
                  const SliverToBoxAdapter(
                    child: _AllArticlesRead(),
                  ),
              ],
            )
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
  final ScrollController controller;

  bool get useFixedOpacity => fullHeight <= appBarHeight;

  @override
  Widget build(BuildContext context) {
    final appBarOpacityState = useState(_setupOpacity());

    useEffect(() {
      appBarOpacityState.value = _setupOpacity();

      void setAppBarOpacity() {
        if (controller.hasClients) {
          final currentOffset = controller.offset;
          final opacityThreshold = fullHeight - appBarHeight * 1.5;
          final opacitySpeed = fullHeight / (appBarHeight * 1.5);

          if (currentOffset <= 0 || currentOffset < opacityThreshold) {
            if (appBarOpacityState.value != 0) appBarOpacityState.value = 0;
            return;
          }

          final factor = (currentOffset / opacityThreshold - 1) * opacitySpeed;
          final opacity = 0.0 + min(factor, 1.0);
          if (appBarOpacityState.value != opacity) appBarOpacityState.value = opacity * 0.8;
        }
      }

      if (!useFixedOpacity) controller.addListener(setAppBarOpacity);
      return () => controller.removeListener(setAppBarOpacity);
    }, [controller, article]);

    return SliverAppBar(
      pinned: true,
      expandedHeight: fullHeight,
      collapsedHeight: appBarHeight,
      toolbarHeight: appBarHeight,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      title: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0.5, 1],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: [
              AppColors.background.withOpacity(appBarOpacityState.value),
              AppColors.background.withOpacity(min(appBarOpacityState.value, 0)),
            ],
          ),
        ),
        height: appBarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.black.withOpacity(appBarOpacityState.value),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    onPressed: () => context.popRoute(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.background.withOpacity(1 - appBarOpacityState.value),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    onPressed: () => context.popRoute(),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
                child: ShareArticleButton(
                  article: article,
                ),
              ),
            ],
          ),
        ),
      ),
      flexibleSpace: const SizedBox(),
    );
  }

  double _setupOpacity() => useFixedOpacity ? 1.0 : 0.0;
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
