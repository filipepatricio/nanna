import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_content_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/article_more_from_section.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_content_section.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PremiumArticleReadView extends HookWidget {
  PremiumArticleReadView({
    required this.cubit,
    required this.mainController,
    this.openedFrom,
  });

  final PremiumArticleViewCubit cubit;
  final ScrollController mainController;
  final String? openedFrom;

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
      if (scrollInfo is ScrollUpdateNotification) {
        final articleHeaderHeight = _getSize(_articleHeaderKey);
        final articleFullHeight = _getSize(_articleContentKey);
        final fixedOffset = mainController.offset - articleHeaderHeight + MediaQuery.of(context).padding.top;
        final newProgress = fixedOffset / articleFullHeight;

        readProgress.value = newProgress.isFinite && !newProgress.isNegative ? newProgress : 0;
      }

      if (scrollInfo is ScrollEndNotification) {
        final articleFullHeight = _getSize(_articleContentKey);
        cubit.updateScrollData(mainController.offset, articleFullHeight);
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);
    final readProgress = useMemoized(() => ValueNotifier(0.0));
    final maxHeight = useMemoized(
      () => MediaQuery.of(context).size.height,
      [MediaQuery.of(context).size.height],
    );

    return state.maybeMap(
      idle: (data) {
        return Stack(
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
                child: Scrollbar(
                  controller: mainController,
                  child: CustomScrollView(
                    controller: mainController,
                    physics: const BottomBouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: ArticleContentView(
                          article: data.article,
                          articleHeaderKey: _articleHeaderKey,
                          articleContentKey: _articleContentKey,
                        ),
                      ),
                      if (data.otherTopicItems.isNotEmpty)
                        SliverToBoxAdapter(
                          child: ArticleMoreFromSection(
                            title: context.l10n.article_moreFromTopic(cubit.topicTitle),
                            items: data.otherTopicItems.buildWidgets(
                              context,
                              cubit,
                              openedFrom,
                            ),
                          ),
                        ),
                      if (data.moreFromBriefItems.isNotEmpty)
                        SliverToBoxAdapter(
                          child: ArticleMoreFromSection(
                            title: context.l10n.article_otherBriefs,
                            items: data.moreFromBriefItems.buildWidgets(context, cubit, openedFrom),
                          ),
                        ),
                      if (data.relatedContentItems.isNotEmpty || data.featuredCategories.isNotEmpty)
                        SliverToBoxAdapter(
                          child: RelatedContentSection(
                            articleId: data.article.metadata.id,
                            featuredCategories: data.featuredCategories,
                            briefId: cubit.briefId,
                            topicId: cubit.topicId,
                            relatedContentItems: data.relatedContentItems,
                            onRelatedContentItemTap: cubit.onRelatedContentItemTap,
                            onRelatedCategoryTap: cubit.onRelatedCategoryTap,
                            openedFrom: openedFrom,
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.pageHorizontalMargin),
                          child: RelaxView.article(),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppDimens.l),
                      ),
                      const SliverToBoxAdapter(
                        child: AudioPlayerBannerPlaceholder(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppDimens.articlePageContentTopPadding(context),
              left: 0,
              right: 0,
              child: _ArticleProgressBar(
                readProgress: readProgress,
                color: data.article.metadata.category.color,
              ),
            ),
          ],
        );
      },
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
            valueColor: AlwaysStoppedAnimation(color ?? AppColors.brandAccent),
            minHeight: 3,
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
    String? openedFrom,
  }) {
    router.popAndPush(
      MediaItemPageRoute(
        article: article,
        briefId: briefId,
        topicId: topicId,
        slug: article.slug,
        openedFrom: openedFrom,
      ),
    );
  }

  void navigateToTopic({
    required TopicPreview topic,
    String? briefId,
    String? openedFrom,
  }) {
    router.popAndPush(
      TopicPage(
        topicSlug: topic.slug,
        briefId: briefId,
        openedFrom: openedFrom,
      ),
    );
  }
}

extension on List<MediaItem> {
  List<Widget> buildWidgets(
    BuildContext context,
    PremiumArticleViewCubit cubit,
    String? openedFrom,
  ) =>
      map<Widget>(
        (mediaItem) => mediaItem.map(
          article: (mediaItemArticle) => MoreFromSectionListItem.article(
            article: mediaItemArticle,
            onItemTap: () {
              cubit.onOtherTopicItemTap(mediaItem);
              context.navigateToArticle(
                article: mediaItemArticle,
                briefId: cubit.briefId,
                topicId: cubit.topicId,
                openedFrom: openedFrom,
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
    String? openedFrom,
  ) =>
      map<Widget>(
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
                  openedFrom: openedFrom,
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
                openedFrom: openedFrom,
              );
            },
          ),
          unknown: (_) => const SizedBox.shrink(),
        ),
      ).toList();
}
