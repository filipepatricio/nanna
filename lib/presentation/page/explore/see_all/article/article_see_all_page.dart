import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_with_background.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/fixed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ArticleSeeAllPage extends HookWidget {
  const ArticleSeeAllPage({
    required this.areaId,
    required this.title,
    required this.referred,
    this.entries,
    Key? key,
  }) : super(key: key);
  final String areaId;
  final String title;
  final List<MediaItemArticle>? entries;
  final ExploreAreaReferred referred;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<ArticleSeeAllPageCubit>();
    final state = useCubitBuilder<ArticleSeeAllPageCubit, ArticleSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(areaId));
    final snackbarController = useMemoized(() => SnackbarController());

    useEffect(
      () {
        cubit.initialize(areaId, entries);
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
                state: state,
                scrollController: scrollController,
                pageStorageKey: pageStorageKey,
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
  final ArticleSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      loading: (_) => const Loader(),
      withPagination: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        snackbarController: snackbarController,
        withLoader: false,
      ),
      loadingMore: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        snackbarController: snackbarController,
        withLoader: true,
      ),
      allLoaded: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        snackbarController: snackbarController,
        withLoader: false,
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _ArticleGrid extends StatelessWidget {
  const _ArticleGrid({
    required this.title,
    required this.pageStorageKey,
    required this.articles,
    required this.scrollController,
    required this.withLoader,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);
  final String title;
  final PageStorageKey pageStorageKey;
  final List<ArticleWithBackground> articles;
  final ScrollController scrollController;
  final bool withLoader;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      key: pageStorageKey,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.l),
          sliver: SliverToBoxAdapter(
            child: AlignedGridView.count(
              physics: const BottomBouncingScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: AppDimens.l,
              mainAxisSpacing: AppDimens.m,
              itemCount: articles.length,
              itemBuilder: (context, index) => _GridItem(
                article: articles[index],
                index: index,
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
    required this.article,
    required this.index,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);
  final ArticleWithBackground article;
  final int index;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return article.map(
      image: (data) => ArticleCover.small(
        article: article.article,
        onTap: () => context.navigateToArticle(article.article),
        snackbarController: snackbarController,
      ),
      color: (data) => ArticleCover.small(
        article: article.article,
        coverColor: AppColors.mockedColors[data.colorIndex % AppColors.mockedColors.length],
        onTap: () => context.navigateToArticle(article.article),
        snackbarController: snackbarController,
      ),
    );
  }
}

extension on BuildContext {
  void navigateToArticle(MediaItemArticle article) {
    pushRoute(
      MediaItemPageRoute(article: article),
    );
  }
}
