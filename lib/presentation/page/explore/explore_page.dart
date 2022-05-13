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
import 'package:better_informed_mobile/presentation/page/explore/highlighted_topics_area/highlighted_topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pills_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/sliver_search_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/explore/small_topics_area/small_topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/topics_area/topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_loading_section.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        controller: scrollController,
        currentPage: context.routeData,
        child: ReadingBannerWrapper(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Stack(
              children: [
                NoScrollGlow(
                  child: RefreshIndicator(
                    color: AppColors.darkGrey,
                    onRefresh: state.maybeMap(
                      search: (_) => searchViewCubit.refresh,
                      orElse: () => cubit.loadExplorePageData,
                    ),
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
                          error: (_) => const _LoadingSection(),
                          orElse: () => const SliverToBoxAdapter(),
                        ),
                        state.maybeMap(
                          idle: (state) => _ItemList(
                            items: state.items,
                          ),
                          search: (_) => SearchView(
                            cubit: searchViewCubit,
                            scrollController: scrollController,
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
                    orElse: () => const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback refreshCallback;

  const _ErrorView({
    required this.refreshCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppDimens.c),
        SvgPicture.asset(AppVectorGraphics.magError),
        const SizedBox(height: AppDimens.l),
        Text(
          LocaleKeys.todaysTopics_oops.tr(),
          style: AppTypography.h3bold,
          textAlign: TextAlign.center,
        ),
        Text(
          LocaleKeys.common_somethingWentWrong.tr(),
          style: AppTypography.h3Normal,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.l),
        Container(
          width: _tryAgainButtonWidth,
          child: FilledButton(
            text: LocaleKeys.common_tryAgain.tr(),
            fillColor: AppColors.textPrimary,
            textColor: AppColors.white,
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
          SizedBox(height: AppDimens.xc),
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
    final isHighlighted = items.any(
      (item) => item.maybeMap(
        pills: (_) => true,
        orElse: () => false,
      ),
    );

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];

          return item.map(
            pills: (item) => ExplorePillsAreaView(
              pills: item.list,
            ),
            stream: (item) => _Area(
              area: item.area,
              orderIndex: index,
              isHighlighted: isHighlighted,
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }
}

class _Area extends HookWidget {
  final ExploreContentArea area;
  final int orderIndex;
  final bool isHighlighted;

  const _Area({
    required this.area,
    required this.orderIndex,
    required this.isHighlighted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();

    return GeneralEventTracker(
      controller: eventController,
      child: ViewVisibilityNotifier(
        detectorKey: Key(area.id),
        onVisible: () {
          eventController.track(
            AnalyticsEvent.exploreAreaPreviewed(
              area.id,
              orderIndex,
            ),
          );
        },
        borderFraction: 0.6,
        child: area.map(
          articles: (area) => ArticleAreaView(area: area, isHighlighted: isHighlighted),
          articlesList: (area) => ArticleListAreaView(area: area),
          topics: (area) => TopicsAreaView(area: area, isHighlighted: isHighlighted),
          smallTopics: (area) => SmallTopicsAreaView(area: area),
          highlightedTopics: (area) => HighlightedTopicsAreaView(area: area),
          unknown: (_) => Container(),
        ),
      ),
    );
  }
}
