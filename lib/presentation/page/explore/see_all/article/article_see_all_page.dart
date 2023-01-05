import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_with_background.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/card_divider.dart';
import 'package:better_informed_mobile/presentation/widget/fixed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    Key? key,
  }) : super(key: key);

  final String title;
  final ArticleSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      loading: (_) => const Loader(),
      withPagination: (state) => _ArticleList(
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
      ),
      loadingMore: (state) => _ArticleList(
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: true,
      ),
      allLoaded: (state) => _ArticleList(
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _ArticleList extends StatelessWidget {
  const _ArticleList({
    required this.pageStorageKey,
    required this.articles,
    required this.scrollController,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final PageStorageKey pageStorageKey;
  final List<ArticleWithBackground> articles;
  final ScrollController scrollController;
  final bool withLoader;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: pageStorageKey,
      controller: scrollController,
      physics: const BottomBouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final article = articles[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  article.map(
                    image: (data) => ArticleCover.medium(
                      article: article.article,
                      onTap: () => context.navigateToArticle(article.article),
                    ),
                    color: (data) => ArticleCover.medium(
                      article: article.article,
                      onTap: () => context.navigateToArticle(article.article),
                    ),
                  ),
                  const CardDivider.cover(),
                ],
              );
            },
            childCount: articles.length,
          ),
        ),
        SeeAllLoadMoreIndicator(show: withLoader),
      ],
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
