import 'dart:core';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_area/article_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_list_area/article_list_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pills_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_history_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/sliver_search_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/explore/small_topics_area/small_topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_loading_section.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ExplorePage extends HookWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ExplorePageCubit>();
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();
    final scrollControllerIdleOffset = useState(0.0);

    final searchViewCubit = useCubit<SearchViewCubit>();
    final searchTextEditingController = useTextEditingController();

    useCubitListener<ExplorePageCubit, ExplorePageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) => showInfoToast(context: context, text: text),
        startExploring: () {
          scrollController.jumpTo(scrollControllerIdleOffset.value);
        },
        startSearching: () {
          scrollController.jumpTo(0);
        },
        startTyping: () {
          scrollControllerIdleOffset.value = scrollController.offset;
        },
        searchHistoryQueryTapped: (query) {
          searchTextEditingController.text = query;
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
      );
    });

    useEffect(
      () {
        cubit.initialize();
        searchViewCubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      body: TabBarListener(
        scrollController: scrollController,
        currentPage: context.routeData,
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.of(context).iconPrimary,
              onRefresh: state.maybeMap(
                search: (_) => searchViewCubit.refresh,
                orElse: () => cubit.loadExplorePageData,
              ),
              child: SnackbarParentView(
                audioPlayerResponsive: true,
                child: CustomScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: scrollController,
                  physics: state.maybeMap(
                    initialLoading: (_) => const NeverScrollableScrollPhysics(),
                    error: (_) => const NeverScrollableScrollPhysics(),
                    orElse: () => getPlatformScrollPhysics(),
                  ),
                  slivers: [
                    state.maybeMap(
                      error: (_) => const SliverAppBar(systemOverlayStyle: SystemUiOverlayStyle.dark),
                      orElse: () => SliverSearchAppBar(
                        explorePageCubit: cubit,
                        searchTextEditingController: searchTextEditingController,
                        searchViewCubit: searchViewCubit,
                      ),
                    ),
                    state.maybeMap(
                      initialLoading: (_) => const _LoadingSection(),
                      idle: (state) => _ItemList(
                        items: state.items,
                      ),
                      search: (_) => SearchView(
                        cubit: searchViewCubit,
                        scrollController: scrollController,
                      ),
                      searchHistory: (state) => SearchHistoryView(
                        explorePageCubit: cubit,
                        searchViewCubit: searchViewCubit,
                        scrollController: scrollController,
                        searchHistory: state.searchHistory,
                      ),
                      error: (_) => SliverFillRemaining(
                        child: Center(
                          child: GeneralErrorView(
                            title: LocaleKeys.common_error_title.tr(),
                            content: LocaleKeys.common_error_body.tr(),
                            retryCallback: cubit.initialize,
                          ),
                        ),
                      ),
                      orElse: () => const SliverToBoxAdapter(),
                    ),
                    const SliverToBoxAdapter(
                      child: AudioPlayerBannerPlaceholder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        const [
          ExploreLoadingView.pills(),
          SizedBox(height: AppDimens.xxl),
          ExploreLoadingView.stream(),
          SizedBox(height: AppDimens.xl),
          ExploreLoadingView.stream(),
          SizedBox(height: AppDimens.xl),
          ExploreLoadingView.stream(),
        ],
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({
    required this.items,
    Key? key,
  }) : super(key: key);

  final List<ExploreItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => items[index].map(
          pills: (item) => ExplorePillsAreaView(
            categories: item.categories,
          ),
          stream: (item) => _Area(
            area: item.area,
            orderIndex: index,
          ),
        ),
        childCount: items.length,
        addAutomaticKeepAlives: false,
      ),
    );
  }
}

class _Area extends HookWidget {
  const _Area({
    required this.area,
    required this.orderIndex,
    Key? key,
  }) : super(key: key);

  final ExploreContentArea area;
  final int orderIndex;

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackingController();

    return GeneralEventTracker(
      controller: eventController,
      child: ViewVisibilityNotifier(
        detectorKey: Key(area.id),
        onVisible: () => eventController.track(
          AnalyticsEvent.exploreAreaPreviewed(
            area.id,
            orderIndex,
          ),
        ),
        borderFraction: 0.6,
        child: area.map(
          articles: (area) => ArticleAreaView(
            area: area,
            isHighlighted: area.isHighlighted,
          ),
          articlesList: (area) => ArticleListAreaView(
            area: area,
          ),
          smallTopics: (area) => SmallTopicsAreaView(
            area: area,
          ),
          unknown: (_) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
