import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_area/article_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_area/article_with_cover_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page_state.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/topics_area/topics_area_view.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _topMargin = 80.0;

class ExplorePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ExplorePageCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    final headerColor = _getHeaderColor(state);

    return Scaffold(
      body: ReadingBannerWrapper(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _Header(color: headerColor),
                  ],
                ),
              ),
              state.maybeMap(
                initialLoading: (_) => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.l),
                    child: Loader(),
                  ),
                ),
                idle: (state) => _Idle(areas: state.areas),
                orElse: () => const SliverToBoxAdapter(
                  child: SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getHeaderColor(ExplorePageState state) {
    return state.maybeMap(
      idle: (idle) {
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

class _Header extends StatelessWidget {
  final Color color;

  const _Header({
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: _topMargin),
          Text(
            LocaleKeys.main_exploreTab.tr(),
            style: AppTypography.hBold,
          ),
          const SizedBox(height: AppDimens.l),
        ],
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
        ),
      ),
    );
  }
}
