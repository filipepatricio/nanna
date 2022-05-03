import 'dart:core';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_area/article_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/highlighted_topics_area/highlighted_topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pills_area_view.dart';
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
import 'package:better_informed_mobile/presentation/widget/scrollable_sliver_app_bar.dart';
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
    final headerColor = _getHeaderColor(state);

    useCubitListener<ExplorePageCubit, ExplorePageState>(cubit, (cubit, state, context) {
      state.whenOrNull(showTutorialToast: (text) => showInfoToast(context: context, text: text));
    });

    useEffect(
      () {
        cubit.initialize();
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
                    onRefresh: cubit.loadExplorePageData,
                    child: CustomScrollView(
                      controller: scrollController,
                      physics: state.maybeMap(
                        initialLoading: (_) => const NeverScrollableScrollPhysics(),
                        error: (_) => const NeverScrollableScrollPhysics(),
                        orElse: () => getPlatformScrollPhysics(),
                      ),
                      slivers: [
                        ScrollableSliverAppBar(
                          scrollController: scrollController,
                          title: LocaleKeys.explore_title.tr(),
                          headerColor: headerColor,
                        ),
                        state.maybeMap(
                          initialLoading: (_) => const _LoadingSection(),
                          error: (_) => const _LoadingSection(),
                          orElse: () => const SliverToBoxAdapter(),
                        ),
                        state.maybeMap(
                          idle: (state) => _ItemList(
                            items: state.items,
                            headerColor: _getHeaderColor(state),
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

  Color _getHeaderColor(ExplorePageState state) {
    return state.maybeMap(
      idle: (idle) {
        final backgroundColor = idle.backgroundColor;
        return backgroundColor == null ? AppColors.background : Color(backgroundColor);
      },
      orElse: () => AppColors.background,
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

class _SearchBarButton extends StatelessWidget {
  const _SearchBarButton({
    required this.headerColor,
    Key? key,
  }) : super(key: key);

  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: headerColor,
        padding: const EdgeInsets.only(bottom: AppDimens.m, left: AppDimens.l, right: AppDimens.l),
        child: GestureDetector(
          onTap: () {
            AutoRouter.of(context).push(const SearchPageRoute());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            height: AppDimens.xxl + AppDimens.xxs,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColors.textGrey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppVectorGraphics.search,
                  color: AppColors.darkGreyBackground,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(width: AppDimens.s),
                Text(
                  LocaleKeys.common_search.tr(),
                  style: AppTypography.h4Medium.copyWith(
                    color: AppColors.textGrey,
                    height: 1.3,
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

class _ItemList extends StatelessWidget {
  const _ItemList({
    required this.items,
    required this.headerColor,
    Key? key,
  }) : super(key: key);

  final List<ExploreItem> items;
  final Color headerColor;

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
              headerColor: headerColor,
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
          topics: (area) => TopicsAreaView(area: area, isHighlighted: isHighlighted),
          smallTopics: (area) => SmallTopicsAreaView(area: area),
          highlightedTopics: (area) => HighlightedTopicsAreaView(area: area),
          unknown: (_) => Container(),
        ),
      ),
    );
  }
}
