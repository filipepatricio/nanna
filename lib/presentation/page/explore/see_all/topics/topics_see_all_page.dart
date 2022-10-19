import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/fixed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TopicsSeeAllPage extends HookWidget {
  const TopicsSeeAllPage({
    required this.areaId,
    required this.title,
    required this.referred,
    this.topics,
    Key? key,
  }) : super(key: key);
  final String areaId;
  final String title;
  final List<TopicPreview>? topics;
  final ExploreAreaReferred referred;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<TopicsSeeAllPageCubit>();
    final state = useCubitBuilder<TopicsSeeAllPageCubit, TopicsSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(areaId));
    final snackbarController = useMemoized(() => SnackbarController());

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
      body: SnackbarParentView(
        controller: snackbarController,
        child: AudioPlayerBannerWrapper(
          layout: AudioPlayerBannerLayout.column,
          child: NextPageLoadExecutor(
            enabled: shouldListen,
            onNextPageLoad: cubit.loadNextPage,
            scrollController: scrollController,
            child: TabBarListener(
              currentPage: context.routeData,
              scrollController: scrollController,
              child: _Body(
                title: title,
                pageStorageKey: pageStorageKey,
                scrollController: scrollController,
                state: state,
                snackbarController: snackbarController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.title,
    required this.state,
    required this.scrollController,
    required this.pageStorageKey,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);
  final String title;
  final TopicsSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      loading: (_) => const Loader(),
      withPagination: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        snackbarController: snackbarController,
        withLoader: false,
      ),
      loadingMore: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        snackbarController: snackbarController,
        withLoader: true,
      ),
      allLoaded: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        snackbarController: snackbarController,
        withLoader: false,
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _TopicGrid extends StatelessWidget {
  const _TopicGrid({
    required this.title,
    required this.pageStorageKey,
    required this.topics,
    required this.scrollController,
    required this.withLoader,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);
  final String title;
  final PageStorageKey pageStorageKey;
  final List<TopicPreview> topics;
  final ScrollController scrollController;
  final bool withLoader;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: pageStorageKey,
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.l),
          sliver: SliverToBoxAdapter(
            child: AlignedGridView.count(
              physics: const BottomBouncingScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              itemCount: topics.length,
              crossAxisSpacing: AppDimens.l,
              mainAxisSpacing: AppDimens.m,
              itemBuilder: (context, index) => _GridItem(
                topic: topics[index],
                snackbarController: snackbarController,
              ),
            ),
          ),
        ),
        SeeAllLoadMoreIndicator(show: withLoader),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({
    required this.topic,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);
  final TopicPreview topic;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return TopicCover.small(
      topic: topic,
      onTap: () => context.pushRoute(
        TopicPage(
          topicSlug: topic.slug,
        ),
      ),
      snackbarController: snackbarController,
    );
  }
}
