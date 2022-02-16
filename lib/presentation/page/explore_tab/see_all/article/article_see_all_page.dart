import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/article_see_all_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/article_see_all_page_state.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/article_with_background.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleSeeAllPage extends HookWidget {
  final String areaId;
  final String title;
  final List<MediaItemArticle> entries;

  const ArticleSeeAllPage({
    required this.areaId,
    required this.title,
    required this.entries,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<ArticleSeeAllPageCubit>();
    final state = useCubitBuilder<ArticleSeeAllPageCubit, ArticleSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(areaId));
    final shouldShowTitle = useMemoized(() => ValueNotifier(false));

    useEffect(() {
      cubit.initialize(areaId, entries);
    }, [cubit]);

    final shouldListen = state.maybeMap(
      withPagination: (_) => true,
      orElse: () => false,
    );
    final screenHeight = MediaQuery.of(context).size.height;
    useEffect(() {
      final listener = shouldListen
          ? () {
              final position = scrollController.position;

              if (position.maxScrollExtent - position.pixels < (screenHeight / 2)) {
                cubit.loadNextPage();
              }
            }
          : () {};
      final titleScrollListener = () {
        shouldShowTitle.value = scrollController.offset > kToolbarHeight;
      };
      scrollController.addListener(listener);
      scrollController.addListener(titleScrollListener);
      return () {
        scrollController.removeListener(listener);
        scrollController.removeListener(titleScrollListener);
      };
    }, [scrollController, shouldListen]);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ValueListenableBuilder<bool>(
              valueListenable: shouldShowTitle,
              builder: (context, value, child) => AppBar(
                    backgroundColor: AppColors.background,
                    centerTitle: true,
                    elevation: value ? 3 : 0,
                    shadowColor: AppColors.shadowDarkColor,
                    titleSpacing: 0,
                    title: value
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: AppDimens.xs),
                            child: Text(
                              title,
                              // To allow for the transition's first state align with the other tab titles
                              style: AppTypography.h4Bold.copyWith(height: 2.25),
                            ))
                        : const SizedBox(),
                    leading: IconButton(
                      padding: const EdgeInsets.only(top: AppDimens.s + AppDimens.xxs),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      iconSize: AppDimens.backArrowSize,
                      color: AppColors.textPrimary,
                      onPressed: () => AutoRouter.of(context).pop(),
                    ),
                  ))),
      body: _Body(
        title: title,
        state: state,
        scrollController: scrollController,
        pageStorageKey: pageStorageKey,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String title;
  final ArticleSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;

  const _Body({
    required this.title,
    required this.state,
    required this.scrollController,
    required this.pageStorageKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      loading: (_) => const Loader(),
      withPagination: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: false,
      ),
      loadingMore: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: true,
      ),
      allLoaded: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: false,
      ),
      orElse: () => const SizedBox(),
    );
  }
}

class _ArticleGrid extends StatelessWidget {
  final String title;
  final PageStorageKey pageStorageKey;
  final List<ArticleWithBackground> articles;
  final ScrollController scrollController;
  final bool withLoader;

  const _ArticleGrid({
    required this.title,
    required this.pageStorageKey,
    required this.articles,
    required this.scrollController,
    required this.withLoader,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      key: pageStorageKey,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              const SizedBox(height: AppDimens.l),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: InformedMarkdownBody(
                  markdown: title,
                  highlightColor: AppColors.transparent,
                  baseTextStyle: AppTypography.h1,
                ),
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _GridItem(
                article: articles[index],
                index: index,
              ),
              childCount: articles.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: AppDimens.exploreAreaArticleSeeAllCoverHeight,
              crossAxisSpacing: AppDimens.m,
              mainAxisSpacing: AppDimens.l,
            ),
          ),
        ),
        SeeAllLoadMoreIndicator(show: withLoader),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  final ArticleWithBackground article;
  final int index;

  const _GridItem({
    required this.article,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return article.map(
          image: (data) => ArticleListItem(
            article: article.article,
            themeColor: AppColors.background,
            height: AppDimens.exploreAreaArticleSeeAllCoverHeight,
          ),
          color: (data) => ArticleListItem(
            article: article.article,
            themeColor: AppColors.background,
            cardColor: AppColors.mockedColors[data.colorIndex % AppColors.mockedColors.length],
            height: AppDimens.exploreAreaArticleSeeAllCoverHeight,
          ),
        );
      },
    );
  }
}
