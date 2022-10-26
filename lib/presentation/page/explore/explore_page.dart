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
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _tryAgainButtonWidth = 150.0;

class ExplorePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ExplorePageCubit>();
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();
    final scrollControllerIdleOffset = useState(0.0);
    final snackbarController = useMemoized(() => SnackbarController(audioPlayerResponsive: true));

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
              color: AppColors.darkGrey,
              onRefresh: state.maybeMap(
                search: (_) => searchViewCubit.refresh,
                orElse: () => cubit.loadExplorePageData,
              ),
              child: SnackbarParentView(
                controller: snackbarController,
                child: CustomScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: scrollController,
                  physics: state.maybeMap(
                    initialLoading: (_) => const NeverScrollableScrollPhysics(),
                    error: (_) => const NeverScrollableScrollPhysics(),
                    orElse: () => getPlatformScrollPhysics(),
                  ),
                  slivers: [
                    SliverSearchAppBar(
                      explorePageCubit: cubit,
                      searchTextEditingController: searchTextEditingController,
                      searchViewCubit: searchViewCubit,
                    ),
                    state.maybeMap(
                      initialLoading: (_) => const _LoadingSection(),
                      orElse: () => const SliverToBoxAdapter(),
                    ),
                    state.maybeMap(
                      idle: (state) => _ItemList(
                        items: state.items,
                        snackbarController: snackbarController,
                      ),
                      search: (_) => SearchView(
                        cubit: searchViewCubit,
                        scrollController: scrollController,
                        snackbarController: snackbarController,
                      ),
                      searchHistory: (state) => SearchHistoryView(
                        explorePageCubit: cubit,
                        searchViewCubit: searchViewCubit,
                        scrollController: scrollController,
                        searchHistory: state.searchHistory,
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
            Align(
              alignment: Alignment.center,
              child: state.maybeMap(
                error: (_) => _ErrorView(refreshCallback: () => cubit.initialize()),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.refreshCallback,
    Key? key,
  }) : super(key: key);
  final VoidCallback refreshCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppDimens.c),
        SvgPicture.asset(AppVectorGraphics.magError),
        const SizedBox(height: AppDimens.l),
        Text(
          LocaleKeys.dailyBrief_oops.tr(),
          style: AppTypography.h3bold,
          textAlign: TextAlign.center,
        ),
        Text(
          LocaleKeys.common_somethingWentWrong.tr(),
          style: AppTypography.h3Normal,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.l),
        SizedBox(
          width: _tryAgainButtonWidth,
          child: FilledButton.black(
            text: LocaleKeys.common_tryAgain.tr(),
            onTap: refreshCallback,
          ),
        ),
      ],
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
          SizedBox(height: AppDimens.c),
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
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final List<ExploreItem> items;
  final SnackbarController snackbarController;

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
            snackbarController: snackbarController,
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
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final ExploreContentArea area;
  final int orderIndex;
  final SnackbarController snackbarController;

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
            snackbarController: snackbarController,
          ),
          articlesList: (area) => ArticleListAreaView(
            area: area,
            snackbarController: snackbarController,
          ),
          smallTopics: (area) => SmallTopicsAreaView(
            area: area,
            snackbarController: snackbarController,
          ),
          unknown: (_) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
