import 'dart:core';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_area/article_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_with_cover_area_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_with_cover_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/topics_area/topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/scrollable_sliver_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliver_tools/sliver_tools.dart';

const _tryAgainButtonWidth = 150.0;
const _maxPillLines = 3;
const _maxPillsPerLine = 3;
const _maxPillsSectionHeight = 170.0;
const _pillLineHeight = 50.0;
const _pillPadding = 8.0;

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
                          initialLoading: (_) => const SliverToBoxAdapter(
                            child: ArticleWithCoverAreaLoadingView.loading(),
                          ),
                          idle: (state) => _Idle(
                            areas: state.areas,
                            showPillsOnExplorePage: state.showPillsOnExplorePage,
                            headerColor: headerColor,
                          ),
                          error: (_) => const SliverToBoxAdapter(
                            child: ArticleWithCoverAreaLoadingView.static(),
                          ),
                          orElse: () => const SliverToBoxAdapter(
                            child: SizedBox(),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: AppDimens.xl + AppDimens.audioBannerHeight),
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
        if (idle.areas.isEmpty) {
          return AppColors.background;
        }
        final firstArea = idle.areas.first;
        return firstArea.maybeMap(
          articleWithFeature: (state) => Color(state.backgroundColor),
          orElse: () => AppColors.background,
        );
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

class _Idle extends StatelessWidget {
  final List<ExploreContentArea> areas;
  final bool showPillsOnExplorePage;
  final Color headerColor;

  const _Idle({
    required this.areas,
    required this.showPillsOnExplorePage,
    required this.headerColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        if (showPillsOnExplorePage) _PillsSection(areas: areas, headerColor: headerColor),
        SliverList(
          delegate: SliverChildListDelegate(
            areas.map((area) => _Area(area: area, orderIndex: areas.indexOf(area))).toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _PillsSection extends HookWidget {
  final List<ExploreContentArea> areas;
  final Color headerColor;

  const _PillsSection({
    required this.areas,
    required this.headerColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lineCount = min(_maxPillLines, (areas.length / _maxPillsPerLine).ceil());
    final height = min(_maxPillsSectionHeight, lineCount * _pillLineHeight + (lineCount > 1 ? _pillPadding : 0));

    return SliverToBoxAdapter(
      child: Container(
        height: height,
        color: headerColor,
        child: MasonryGridView.count(
          padding: const EdgeInsets.only(left: AppDimens.l, right: AppDimens.m),
          scrollDirection: Axis.horizontal,
          crossAxisCount: lineCount,
          mainAxisSpacing: _pillPadding,
          crossAxisSpacing: _pillPadding,
          itemCount: areas.length,
          itemBuilder: (context, index) {
            return areas[index].map(
              articles: (area) => _AreaPillItem(
                title: area.title,
                index: index,
                onTap: () => AutoRouter.of(context).push(
                  ArticleSeeAllPageRoute(
                    areaId: area.id,
                    title: area.title,
                    entries: area.articles,
                    referred: ExploreAreaReferred.pill,
                  ),
                ),
              ),
              articleWithFeature: (area) => _AreaPillItem(
                title: area.title,
                index: index,
                onTap: () => AutoRouter.of(context).push(
                  ArticleSeeAllPageRoute(
                    areaId: area.id,
                    title: area.title,
                    entries: [area.featuredArticle] + area.articles,
                    referred: ExploreAreaReferred.pill,
                  ),
                ),
              ),
              topics: (area) => _AreaPillItem(
                title: area.title,
                index: index,
                onTap: () => context.pushRoute(
                  TopicsSeeAllPageRoute(
                    areaId: area.id,
                    title: area.title,
                    topics: area.topics,
                    referred: ExploreAreaReferred.pill,
                  ),
                ),
              ),
              unknown: (_) => const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}

class _Area extends HookWidget {
  final ExploreContentArea area;
  final int orderIndex;

  const _Area({
    required this.area,
    required this.orderIndex,
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
          articles: (area) => ArticleAreaView(area: area),
          articleWithFeature: (area) => ArticleWithCoverAreaView(area: area),
          topics: (area) => TopicsAreaView(area: area),
          unknown: (_) => Container(),
        ),
      ),
    );
  }
}

class _AreaPillItem extends StatelessWidget {
  final String title;
  final int index;
  final VoidCallback onTap;
  final Color? color;

  const _AreaPillItem({
    required this.title,
    required this.index,
    required this.onTap,
    this.color = AppColors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.dividerGreyLight,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m, horizontal: AppDimens.l),
        child: Text(
          title,
          style: AppTypography.b3Regular.copyWith(height: 1),
        ),
      ),
    );
  }
}
