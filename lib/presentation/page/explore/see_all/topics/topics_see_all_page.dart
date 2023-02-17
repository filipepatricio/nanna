import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/card_divider.dart';
import 'package:better_informed_mobile/presentation/widget/informed_sliver_cupertino_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicsSeeAllPage extends HookWidget {
  const TopicsSeeAllPage({
    required this.areaId,
    required this.title,
    required this.referred,
    required this.areaBackgroundColor,
    this.topics,
    Key? key,
  }) : super(key: key);

  final String areaId;
  final String title;
  final List<TopicPreview>? topics;
  final Color? areaBackgroundColor;
  final ExploreAreaReferred referred;

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
      body: SnackbarParentView(
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
                areaBackgroundColor: areaBackgroundColor,
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
    required this.areaBackgroundColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final TopicsSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;
  final Color? areaBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return state.map(
      loading: (_) => _LoadingView(
        title: title,
        areaBackgroundColor: areaBackgroundColor,
      ),
      withPagination: (state) => _TopicList(
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        title: title,
        areaBackgroundColor: areaBackgroundColor,
      ),
      loadingMore: (state) => _TopicList(
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        title: title,
        areaBackgroundColor: areaBackgroundColor,
        withLoader: true,
      ),
      allLoaded: (state) => _TopicList(
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        title: title,
        areaBackgroundColor: areaBackgroundColor,
      ),
    );
  }
}

class _TopicList extends StatelessWidget {
  const _TopicList({
    required this.pageStorageKey,
    required this.topics,
    required this.scrollController,
    required this.title,
    required this.areaBackgroundColor,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final PageStorageKey pageStorageKey;
  final List<TopicPreview> topics;
  final ScrollController scrollController;
  final String title;
  final Color? areaBackgroundColor;
  final bool withLoader;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: pageStorageKey,
      controller: scrollController,
      physics: const BottomBouncingScrollPhysics(),
      slivers: [
        _AppBar(
          title: title,
          backgroundColor: areaBackgroundColor,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final topic = topics[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TopicCover.medium(
                    topic: topic,
                    onTap: () => context.pushRoute(
                      TopicPage(topicSlug: topic.slug),
                    ),
                  ),
                  const CardDivider.cover()
                ],
              );
            },
            childCount: topics.length,
          ),
        ),
        SeeAllLoadMoreIndicator(show: withLoader),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({
    required this.title,
    required this.areaBackgroundColor,
  });

  final String title;
  final Color? areaBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BottomBouncingScrollPhysics(),
      slivers: [
        _AppBar(
          title: title,
          backgroundColor: areaBackgroundColor,
        ),
        const SliverPadding(
          padding: EdgeInsets.symmetric(vertical: AppDimens.m),
          sliver: SliverToBoxAdapter(
            child: Loader(),
          ),
        ),
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.title,
    required this.backgroundColor,
  });

  final String title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InformedSliverCupertinoAppBar(
      leading: BackTextButton(
        color: AppColors.light.textPrimary,
        text: context.l10n.explore_title,
      ),
      title: title,
      backgroundColor: backgroundColor ?? AppColors.brandAccent,
      textColor: AppColors.light.textPrimary,
    );
  }
}
