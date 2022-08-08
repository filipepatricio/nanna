import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image_view.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_gesture_manager.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/article_other_brief_items_section.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_content_section.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/informed_tab_bar.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/use_automatic_keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PremiumArticleReadView extends HookWidget {
  PremiumArticleReadView({
    required this.cubit,
    required this.articleController,
    required this.pageController,
    required this.mainController,
    this.readArticleProgress,
    Key? key,
  }) : super(key: key);

  final ScrollController articleController;
  final PageController pageController;
  final ScrollController mainController;
  final PremiumArticleViewCubit cubit;
  final double? readArticleProgress;

  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articlePageKey = GlobalKey();

  bool get articleWithImage => cubit.article.metadata.hasImage;

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
    Function() onScrollEnd,
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
          if ((pageController.page ?? 0) >= 1) {
            showTabBar.value = true;
          }

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
    final state = useCubitBuilder(cubit);
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
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) => _updateScrollPosition(
          scrollInfo,
          showTabBar,
          readProgress,
          dynamicListenPosition,
          maxHeight,
          showAudioFloatingButton.value,
          context,
          () {
            final nexController = gestureManager.getNextController();
            if (nexController != null) {
              gestureManager.switchControllers(nexController);
            }
          },
        ),
        child: state.maybeMap(
          orElse: () => const SizedBox.shrink(),
          idle: (data) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                physics: const NeverScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                controller: pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (page) {
                  showTabBar.value = false;
                },
                children: [
                  if (articleWithImage)
                    ArticleImageView(
                      article: cubit.article.metadata,
                      controller: pageController,
                    ),
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
                              article: cubit.article,
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
                          articleId: cubit.article.metadata.id,
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

class _ArticleContentView extends StatefulHookWidget {
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
  final PremiumArticleViewCubit cubit;
  final Key articleContentKey;

  @override
  State<_ArticleContentView> createState() => _ArticleContentViewState();
}

class _ArticleContentViewState extends State<_ArticleContentView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomScrollView(
                primary: false,
                physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                controller: widget.articleController,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        ArticleContentView(
                          article: widget.article,
                          articleContentKey: widget.articleContentKey,
                          scrollToPosition: () => _scrollToPosition(widget.readProgress.value),
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: AppDimens.xxc,
                    ),
                  ),
                ],
              ),
            ),
            _ArticleProgressBar(readProgress: widget.readProgress),
          ],
        ),
        if (widget.article.metadata.hasAudioVersion)
          _AnimatedAudioButton(
            dynamicPosition: widget.dynamicPosition,
            readProgress: widget.readProgress,
            article: widget.article.metadata,
          ),
      ],
    );
  }

  void _scrollToPosition(double? readArticleProgress) {
    if (readArticleProgress != null && readArticleProgress != 1.0) {
      final scrollPosition = widget.cubit.scrollData.contentOffset +
          ((widget.articleController.position.maxScrollExtent - widget.cubit.scrollData.contentOffset) *
              readArticleProgress);
      widget.articleController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
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
