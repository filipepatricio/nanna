import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/article_more_from_section.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_content_section.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PremiumArticleReadView extends HookWidget {
  PremiumArticleReadView({
    required this.cubit,
    required this.mainController,
    required this.snackbarController,
    required this.actionsBarColorModeNotifier,
    required this.onAudioBannerTap,
    Key? key,
  }) : super(key: key);

  final PremiumArticleViewCubit cubit;
  final ScrollController mainController;
  final SnackbarController snackbarController;
  final ValueNotifier<ArticleActionsBarColorMode> actionsBarColorModeNotifier;
  final VoidCallback? onAudioBannerTap;

  final GlobalKey _articleContentKey = GlobalKey();
  final GlobalKey _articleHeaderKey = GlobalKey();

  double _getSize(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.size;
    return position?.height ?? 0;
  }

  bool _updateScrollPosition(
    ScrollNotification scrollInfo,
    ValueNotifier<double> readProgress,
    double fullHeight,
    BuildContext context,
  ) {
    if (mainController.hasClients) {
      final articleHeaderHeight = _getSize(_articleHeaderKey);
      final articleFullHeight = articleHeaderHeight + _getSize(_articleContentKey);
      final newProgress = mainController.offset / articleFullHeight;

      if (scrollInfo is ScrollUpdateNotification) {
        readProgress.value = newProgress.isFinite ? newProgress : 0;

        actionsBarColorModeNotifier.value = mainController.offset >= articleHeaderHeight
            ? ArticleActionsBarColorMode.background
            : ArticleActionsBarColorMode.custom;
      }

      if (scrollInfo is ScrollEndNotification) {
        cubit.updateScrollData(mainController.offset, articleFullHeight);
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);
    final state = useCubitBuilder(cubit);
    final readProgress = useMemoized(() => ValueNotifier(0.0));
    final maxHeight = useMemoized(
      () => MediaQuery.of(context).size.height,
      [MediaQuery.of(context).size.height],
    );

    return state.maybeMap(
      idle: (data) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) => _updateScrollPosition(
              scrollInfo,
              readProgress,
              maxHeight,
              context,
            ),
            child: AudioPlayerBannerWrapper(
              layout: AudioPlayerBannerLayout.stack,
              onTap: onAudioBannerTap,
              child: Scrollbar(
                controller: mainController,
                child: CustomScrollView(
                  controller: mainController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: ArticleContentView(
                        article: data.article,
                        articleHeaderKey: _articleHeaderKey,
                        articleContentKey: _articleContentKey,
                        snackbarController: snackbarController,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          if (data.otherTopicItems.isNotEmpty)
                            ArticleMoreFromSection(
                              title: LocaleKeys.article_moreFromTopic.tr(args: [cubit.topicTitle]),
                              items: data.otherTopicItems.buildWidgets(context, cubit, snackbarController),
                            )
                          else if (data.moreFromBriefItems.isNotEmpty)
                            ArticleMoreFromSection(
                              title: LocaleKeys.article_otherBriefs.tr(),
                              items: data.moreFromBriefItems.buildWidgets(context, cubit, snackbarController),
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
                        snackbarController: snackbarController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _ArticleProgressBar(
              readProgress: readProgress,
              color: data.article.metadata.category.color,
            ),
          ),
        ],
      ),
      orElse: Container.new,
    );
  }
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
  List<Widget> buildWidgets(
    BuildContext context,
    PremiumArticleViewCubit cubit,
    SnackbarController snackbarController,
  ) =>
      map<Widget>(
        (mediaItem) => mediaItem.map(
          article: (mediaItemArticle) => MoreFromSectionListItem.article(
            article: mediaItemArticle,
            snackbarController: snackbarController,
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
  List<Widget> buildWidgets(
    BuildContext context,
    PremiumArticleViewCubit cubit,
    SnackbarController snackbarController,
  ) =>
      map<Widget>(
        (briefEntryItem) => briefEntryItem.map(
          article: (briefItemArticle) => briefItemArticle.article.map(
            article: (mediaItemArticle) => MoreFromSectionListItem.article(
              article: mediaItemArticle,
              snackbarController: snackbarController,
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
            snackbarController: snackbarController,
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
