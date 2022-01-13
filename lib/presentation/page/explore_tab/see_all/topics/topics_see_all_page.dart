import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/topics/topics_see_all_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/topics/topics_see_all_page_state.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_data.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover_small.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicsSeeAllPage extends HookWidget {
  final String areaId;
  final String title;
  final List<Topic> topics;

  const TopicsSeeAllPage({
    required this.areaId,
    required this.title,
    required this.topics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<TopicsSeeAllPageCubit>();
    final state = useCubitBuilder<TopicsSeeAllPageCubit, TopicsSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(areaId));

    useEffect(() {
      cubit.initialize(areaId, topics);
    }, [cubit]);

    final shouldListen = state.maybeMap(
      withPagination: (_) => true,
      orElse: () => false,
    );
    final screenHeight = MediaQuery.of(context).size.height;
    useEffect(() {
      final listener = shouldListen
          ? () {
              final position = scrollController.position;

              if (position.maxScrollExtent - position.pixels < (screenHeight / 2)) {
                cubit.loadNextPage();
              }
            }
          : () {};
      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController, shouldListen]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: false,
        elevation: 3,
        titleSpacing: 0,
        shadowColor: AppColors.shadowDarkColor,
        title: Text(LocaleKeys.explore_title.tr(), style: AppTypography.h3bold.copyWith(height: 1.0)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: AppDimens.backArrowSize,
          color: AppColors.textPrimary,
          onPressed: () => AutoRouter.of(context).pop(),
        ),
      ),
      body: _Body(
        title: title,
        pageStorageKey: pageStorageKey,
        scrollController: scrollController,
        state: state,
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
    return state.maybeMap(
      loading: (_) => const Loader(),
      withPagination: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        withLoader: false,
      ),
      loadingMore: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        withLoader: true,
      ),
      allLoaded: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        withLoader: false,
      ),
      orElse: () => const SizedBox(),
    );
  }
}

class _TopicGrid extends StatelessWidget {
  final String title;
  final PageStorageKey pageStorageKey;
  final List<Topic> topics;
  final ScrollController scrollController;
  final bool withLoader;

  const _TopicGrid({
    required this.title,
    required this.pageStorageKey,
    required this.topics,
    required this.scrollController,
    required this.withLoader,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
              (context, index) => _GridItem(topic: topics[index]),
              childCount: topics.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: AppDimens.exploreAreaTopicSeeAllCoverHeight,
              mainAxisSpacing: AppDimens.m,
            ),
          ),
        ),
        SeeAllLoadMoreIndicator(show: withLoader),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  final Topic topic;

  const _GridItem({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTopicTap(context, topic),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return PageViewStackedCards.random(
            coverSize: Size(constraints.maxWidth, AppDimens.exploreAreaTopicSeeAllCoverHeight),
            child: ReadingListCoverSmall(topic: topic),
          );
        },
      ),
    );
  }

  void _onTopicTap(BuildContext context, Topic topic) {
    AutoRouter.of(context).push(
      TopicPageRoute(pageData: TopicPageData.item(topic: topic)),
    );
  }
}
