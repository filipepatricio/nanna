import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/fixed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicsSeeAllPage extends HookWidget {
  final String areaId;
  final String title;
  final List<TopicPreview> topics;
  final ExploreAreaReferred referred;

  const TopicsSeeAllPage({
    required this.areaId,
    required this.title,
    required this.topics,
    required this.referred,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<TopicsSeeAllPageCubit>();
    final state = useCubitBuilder<TopicsSeeAllPageCubit, TopicsSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(areaId));

    useEffect(
      () {
        cubit.initialize(areaId, topics);
      },
      [cubit],
    );

    final shouldListen = state.maybeMap(
      withPagination: (_) => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: FixedAppBar(scrollController: scrollController, title: title),
      body: AudioPlayerBannerWrapper(
        layout: AudioPlayerBannerLayout.column,
        child: NextPageLoadExecutor(
          enabled: shouldListen,
          onNextPageLoad: cubit.loadNextPage,
          scrollController: scrollController,
          child: TabBarListener(
            currentPage: context.routeData,
            controller: scrollController,
            child: _Body(
              title: title,
              pageStorageKey: pageStorageKey,
              scrollController: scrollController,
              state: state,
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String title;
  final TopicsSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;

  const _Body({
    required this.title,
    required this.state,
    required this.scrollController,
    required this.pageStorageKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackedCardsRandomVariantBuilder<StackedCardsVariant>(
      variants: StackedCardsVariant.values,
      count: state.maybeMap(
        loadingMore: (state) => state.topics.length,
        withPagination: (state) => state.topics.length,
        allLoaded: (state) => state.topics.length,
        orElse: () => 0,
      ),
      builder: (cardVariants) {
        return state.maybeMap(
          loading: (_) => const Loader(),
          withPagination: (state) => _TopicGrid(
            title: title,
            pageStorageKey: pageStorageKey,
            topics: state.topics,
            scrollController: scrollController,
            withLoader: false,
            cardVariants: cardVariants,
          ),
          loadingMore: (state) => _TopicGrid(
            title: title,
            pageStorageKey: pageStorageKey,
            topics: state.topics,
            scrollController: scrollController,
            withLoader: true,
            cardVariants: cardVariants,
          ),
          allLoaded: (state) => _TopicGrid(
            title: title,
            pageStorageKey: pageStorageKey,
            topics: state.topics,
            scrollController: scrollController,
            withLoader: false,
            cardVariants: cardVariants,
          ),
          orElse: () => const SizedBox(),
        );
      },
    );
  }
}

class _TopicGrid extends StatelessWidget {
  final String title;
  final PageStorageKey pageStorageKey;
  final List<TopicPreview> topics;
  final ScrollController scrollController;
  final bool withLoader;
  final List<StackedCardsVariant> cardVariants;

  const _TopicGrid({
    required this.title,
    required this.pageStorageKey,
    required this.topics,
    required this.scrollController,
    required this.withLoader,
    required this.cardVariants,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoScrollGlow(
      child: CustomScrollView(
        controller: scrollController,
        key: pageStorageKey,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                const SizedBox(height: AppDimens.l),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: InformedMarkdownBody(
                    markdown: title,
                    highlightColor: AppColors.transparent,
                    baseTextStyle: AppTypography.h1,
                  ),
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _GridItem(
                  topic: topics[index],
                  cardVariant: cardVariants[index],
                ),
                childCount: topics.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: AppDimens.exploreAreaTopicSeeAllCoverHeight,
                mainAxisSpacing: AppDimens.xl,
                crossAxisSpacing: AppDimens.l,
              ),
            ),
          ),
          SeeAllLoadMoreIndicator(show: withLoader),
        ],
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final TopicPreview topic;
  final StackedCardsVariant cardVariant;

  const _GridItem({
    required this.topic,
    required this.cardVariant,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTopicTap(context, topic),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return StackedCards.variant(
            variant: cardVariant,
            coverSize: Size(
              constraints.maxWidth,
              AppDimens.exploreAreaTopicSeeAllCoverHeight,
            ),
            child: TopicCover.small(
              topic: topic,
            ),
          );
        },
      ),
    );
  }

  void _onTopicTap(BuildContext context, TopicPreview topic) {
    AutoRouter.of(context).push(
      TopicPage(
        topicSlug: topic.slug,
      ),
    );
  }
}
