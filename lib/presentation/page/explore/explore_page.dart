import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
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
                          initialLoading: (_) => const SliverToBoxAdapter(
                            child: ArticleWithCoverAreaLoadingView.loading(),
                          ),
                          idle: (state) => _Idle(areas: state.areas),
                          error: (_) => const SliverToBoxAdapter(
                            child: ArticleWithCoverAreaLoadingView.static(),
                          ),
                          orElse: () => const SliverToBoxAdapter(
                            child: SizedBox(),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: AppDimens.xl))
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

  const _Idle({
    required this.areas,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        areas.map((area) => _Area(area: area, orderIndex: areas.indexOf(area))).toList(growable: false),
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