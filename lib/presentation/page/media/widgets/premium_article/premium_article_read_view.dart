import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_gesture_manager.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/article_other_brief_items_section.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_content_section.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/informed_tab_bar.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PremiumArticleReadView extends HookWidget {
  PremiumArticleReadView({
    required this.cubit,
    required this.articleController,
    required this.mainController,
    required this.snackbarController,
    required this.actionsBarColorModeNotifier,
    Key? key,
  }) : super(key: key);

  final PremiumArticleViewCubit cubit;
  final ScrollController articleController;
  final ScrollController mainController;
  final SnackbarController snackbarController;
  final ValueNotifier<ArticleActionsBarColorMode> actionsBarColorModeNotifier;

  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articleHeaderKey = GlobalKey();

  void calculateArticleContentOffset() {
    const globalPageOffset = 0.0;
    final globalContentOffset = _calculateGlobalOffset(_articleContentKey) ?? 0;
    cubit.setupScrollData(globalContentOffset, globalPageOffset);
  }

  double? _getSize(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.size;
    return position?.height;
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
    double fullHeight,
    BuildContext context,
    Function() onScrollEnd,
  ) {
    if (articleController.hasClients) {
      if (scrollInfo is ScrollUpdateNotification) {
        final articleHeaderHeight = _getSize(_articleHeaderKey) ?? 0;
        final newProgress = articleController.offset / articleController.position.maxScrollExtent;

        final primaryDelta = scrollInfo.dragDetails?.primaryDelta ?? 0;
        if (primaryDelta.abs() > 1 && scrollInfo is! ScrollEndNotification) {
          showTabBar.value = primaryDelta > 0 && articleController.offset >= articleHeaderHeight / 2;
        }

        readProgress.value = newProgress.isFinite ? newProgress : 0;

        actionsBarColorModeNotifier.value = articleController.offset >= articleHeaderHeight
            ? ArticleActionsBarColorMode.background
            : ArticleActionsBarColorMode.custom;

        if (articleController.position.pixels == articleController.position.maxScrollExtent &&
            mainController.position.pixels == mainController.position.minScrollExtent &&
            scrollInfo.dragDetails?.primaryDelta == null) {
          onScrollEnd();
        }
      }

      if (scrollInfo is ScrollEndNotification) {
        var readScrollOffset = articleController.offset - cubit.scrollData.contentOffset;
        if (readScrollOffset < 0) {
          readScrollOffset = fullHeight - (cubit.scrollData.contentOffset - articleController.offset);
        }
        if (scrollInfo.metrics.pixels == mainController.position.maxScrollExtent) {
          showTabBar.value = true;
        }
        if (scrollInfo.metrics.pixels == mainController.position.minScrollExtent) {
          showTabBar.value = false;
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
    final state = useCubitBuilder(cubit);
    final gestureManager = useMemoized(
      () => MediaItemPageGestureManager(
        context: context,
        articleViewController: articleController,
        mainViewController: mainController,
      ),
      [state.articleWithImage],
    );
    final readProgress = useMemoized(() => ValueNotifier(0.0));
    final showTabBar = useState(false);
    final maxHeight = useMemoized(
      () => MediaQuery.of(context).size.height,
      [MediaQuery.of(context).size.height],
    );

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => calculateArticleContentOffset(),
        );
      },
      [],
    );

    return RawGestureDetector(
      gestures: Map<Type, GestureRecognizerFactory>.fromEntries(
        [gestureManager.dragGestureRecognizer, gestureManager.tapGestureRecognizer],
      ),
      behavior: HitTestBehavior.opaque,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) => _updateScrollPosition(
          scrollInfo,
          showTabBar,
          readProgress,
          maxHeight,
          context,
          () {
            final nexController = gestureManager.getNextController();
            if (nexController != null) {
              gestureManager.switchControllers(nexController);
            }
          },
        ),
        child: state.maybeMap(
          orElse: Container.new,
          idle: (data) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomScrollView(
                controller: mainController,
                physics: const NeverScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                slivers: [
                  SliverFillViewport(
                    delegate: SliverChildListDelegate(
                      [
                        _ArticleContentView(
                          cubit: cubit,
                          article: data.article,
                          articleContentKey: _articleContentKey,
                          articleHeaderKey: _articleHeaderKey,
                          articleController: articleController,
                          snackbarController: snackbarController,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        if (data.otherTopicItems.isNotEmpty)
                          ArticleMoreFromSection(
                            title: LocaleKeys.article_moreFromTopic.tr(args: [cubit.topicTitle]),
                            items: data.otherTopicItems.buildWidgets(context, cubit),
                          )
                        else if (data.moreFromBriefItems.isNotEmpty)
                          ArticleMoreFromSection(
                            title: LocaleKeys.article_otherBriefs.tr(),
                            items: data.moreFromBriefItems.buildWidgets(context, cubit),
                          ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: RelatedContentSection(
                      articleId: data.article.metadata.id,
                      featuredCategories: data.featuredCategories,
                      briefId: cubit.briefId,
                      topicId: cubit.topicId,
                      relatedContentItems: data.relatedContentItems,
                      onRelatedContentItemTap: cubit.onRelatedContentItemTap,
                      onRelatedCategoryTap: cubit.onRelatedCategoryTap,
                    ),
                  ),
                ],
              ),
              InformedTabBar.floating(show: showTabBar.value),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _ArticleProgressBar(
                  readProgress: readProgress,
                  color: data.article.metadata.category?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleContentView extends StatefulHookWidget {
  const _ArticleContentView({
    required this.cubit,
    required this.article,
    required this.articleController,
    required this.articleContentKey,
    required this.articleHeaderKey,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final Article article;
  final PremiumArticleViewCubit cubit;
  final ScrollController articleController;
  final Key articleContentKey;
  final Key articleHeaderKey;
  final SnackbarController snackbarController;

  @override
  State<_ArticleContentView> createState() => _ArticleContentViewState();
}

class _ArticleContentViewState extends State<_ArticleContentView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            primary: false,
            physics: NeverScrollableScrollPhysics(
              parent: getPlatformScrollPhysics(),
            ),
            controller: widget.articleController,
            slivers: [
              SliverToBoxAdapter(
                child: ArticleContentView(
                  article: widget.article,
                  articleHeaderKey: widget.articleHeaderKey,
                  articleContentKey: widget.articleContentKey,
                  snackbarController: widget.snackbarController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ArticleProgressBar extends HookWidget {
  const _ArticleProgressBar({
    required this.readProgress,
    this.color,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<double> readProgress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: readProgress,
        builder: (context, value, _) {
          return LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.transparent,
            valueColor: AlwaysStoppedAnimation(color ?? AppColors.pastelBlue),
            minHeight: 2,
          );
        },
      ),
    );
  }
}

extension on BuildContext {
  void navigateToArticle({
    required MediaItemArticle article,
    String? briefId,
    String? topicId,
  }) {
    router.popAndPush(
      MediaItemPageRoute(
        article: article,
        briefId: briefId,
        topicId: topicId,
        slug: article.slug,
      ),
    );
  }

  void navigateToTopic({
    required TopicPreview topic,
    String? briefId,
  }) {
    router.popAndPush(
      TopicPage(
        topicSlug: topic.slug,
        briefId: briefId,
      ),
    );
  }
}

extension on List<MediaItem> {
  List<Widget> buildWidgets(BuildContext context, PremiumArticleViewCubit cubit) => map<Widget>(
        (mediaItem) => mediaItem.map(
          article: (mediaItemArticle) => MoreFromSectionListItem.article(
            article: mediaItemArticle,
            onItemTap: () {
              cubit.onOtherTopicItemTap(mediaItem);
              context.navigateToArticle(
                article: mediaItemArticle,
                briefId: cubit.briefId,
                topicId: cubit.topicId,
              );
            },
          ),
          unknown: (_) => const SizedBox.shrink(),
        ),
      ).toList();
}

extension on List<BriefEntryItem> {
  List<Widget> buildWidgets(BuildContext context, PremiumArticleViewCubit cubit) => map<Widget>(
        (briefEntryItem) => briefEntryItem.map(
          article: (briefItemArticle) => briefItemArticle.article.map(
            article: (mediaItemArticle) => MoreFromSectionListItem.article(
              article: mediaItemArticle,
              onItemTap: () {
                cubit.onMoreFromBriefItemTap(briefEntryItem);
                context.navigateToArticle(
                  article: mediaItemArticle,
                  briefId: cubit.briefId,
                  topicId: cubit.topicId,
                );
              },
            ),
            unknown: (_) => const SizedBox.shrink(),
          ),
          topicPreview: (briefItemTopic) => MoreFromSectionListItem.topic(
            topic: briefItemTopic.topicPreview,
            onItemTap: () {
              cubit.onMoreFromBriefItemTap(briefEntryItem);
              context.navigateToTopic(
                topic: briefItemTopic.topicPreview,
                briefId: cubit.briefId,
              );
            },
          ),
          unknown: (_) => const SizedBox.shrink(),
        ),
      ).toList();
}

extension on PremiumArticleViewState {
  bool get articleWithImage {
    return mapOrNull(
          idle: (state) => state.article.metadata.hasImage,
        ) ??
        false;
  }
}
