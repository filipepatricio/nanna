import 'dart:core';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_area/article_area_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
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
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _tryAgainButtonWidth = 150.0;

class ExplorePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ExplorePageCubit>();
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();
    final headerColor = _getHeaderColor(state);

    final searchViewCubit = useCubit<SearchViewCubit>();
    final searchTextEditingController = useTextEditingController();

    useCubitListener<ExplorePageCubit, ExplorePageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) => showInfoToast(context: context, text: text),
        search: () {
          scrollController.jumpTo(0);
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
                        search: (_) => const NeverScrollableScrollPhysics(),
                        error: (_) => const NeverScrollableScrollPhysics(),
                        orElse: () => getPlatformScrollPhysics(),
                      ),
                      slivers: [
                        SliverAppBar(
                          backgroundColor: AppColors.background,
                          systemOverlayStyle: SystemUiOverlayStyle.dark,
                          shadowColor: AppColors.black40,
                          pinned: true,
                          centerTitle: false,
                          elevation: 3.0,
                          expandedHeight: AppDimens.appBarHeight,
                          actions: [
                            _CancelButton(
                              cubit: cubit,
                              searchController: searchTextEditingController,
                            ),
                          ],
                          title: _SearchBar(
                            explorePageCubit: cubit,
                            searchViewCubit: searchViewCubit,
                            searchController: searchTextEditingController,
                          ),
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
                          search: (_) => SearchView(
                            cubit: searchViewCubit,
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

class _CancelButton extends HookWidget {
  const _CancelButton({
    required this.cubit,
    required this.searchController,
    Key? key,
  }) : super(key: key);

  final ExplorePageCubit cubit;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);
    return KeyboardVisibilityBuilder(
      builder: (context, visible) => Container(
        child: visible || state.maybeMap(search: (_) => true, orElse: () => false)
            ? Container(
                margin: const EdgeInsets.only(right: AppDimens.m),
                child: TextButton(
                  onPressed: () {
                    cubit.idle();
                    searchController.clear();
                    final currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Text(
                    LocaleKeys.common_cancel.tr(),
                    style: AppTypography.h4Bold.copyWith(
                      color: AppColors.darkGreyBackground,
                      height: 1.3,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
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

class _SearchBar extends HookWidget {
  const _SearchBar({
    required this.explorePageCubit,
    required this.searchViewCubit,
    required this.searchController,
    Key? key,
  }) : super(key: key);

  final ExplorePageCubit explorePageCubit;
  final SearchViewCubit searchViewCubit;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final query = useState('');

    useEffect(
      () {
        final listener = () {
          query.value = searchController.text;
          searchViewCubit.search(query.value);

          if (query.value.isNotEmpty) {
            explorePageCubit.search();
          } else {
            explorePageCubit.idle();
          }
        };
        searchController.addListener(listener);
        return () => searchController.removeListener(listener);
      },
      [SearchViewCubit, searchController],
    );

    return Container(
      height: AppDimens.searchBarHeight,
      margin: const EdgeInsets.only(left: AppDimens.s),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.textGrey,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: searchController,
        autofocus: false,
        cursorHeight: AppDimens.m,
        cursorColor: AppColors.darkGreyBackground,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: LocaleKeys.common_search.tr(),
          hintStyle: AppTypography.h4Medium.copyWith(
            color: AppColors.textGrey,
            height: 1.23,
          ),
          prefixIcon: SvgPicture.asset(
            AppVectorGraphics.search,
            color: AppColors.darkGreyBackground,
            fit: BoxFit.scaleDown,
          ),
          suffixIcon: query.value.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchController.text = '';
                  },
                  child: SvgPicture.asset(
                    AppVectorGraphics.clearText,
                    height: AppDimens.xs,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : const SizedBox(),
        ),
        style: AppTypography.h4Medium.copyWith(
          color: AppColors.darkGreyBackground,
          height: 1.3,
        ),
        onTap: () {
          explorePageCubit.typing();
        },
      ),
    );
  }
}
