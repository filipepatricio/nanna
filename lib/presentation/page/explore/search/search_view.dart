import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliver_tools/sliver_tools.dart';

const _gridColumnCount = 2;

class SearchView extends HookWidget {
  const SearchView({
    required this.cubit,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final SearchViewCubit cubit;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);

    return NextPageLoadExecutor(
      enabled: true,
      onNextPageLoad: cubit.loadNextPage,
      scrollController: scrollController,
      child: state.maybeMap(
        initial: (_) => const SliverToBoxAdapter(child: SizedBox.shrink()),
        loading: (_) => const SliverFillRemaining(
          child: Center(
            child: Loader(
              color: AppColors.limeGreen,
            ),
          ),
        ),
        empty: (state) => SliverToBoxAdapter(
          child: _EmptyView(query: state.query),
        ),
        idle: (state) => _Idle(
          cubit: cubit,
          results: state.results,
          scrollController: scrollController,
        ),
        loadMore: (state) => _Idle(
          cubit: cubit,
          results: state.results,
          scrollController: scrollController,
          withLoader: true,
        ),
        allLoaded: (state) => _Idle(
          cubit: cubit,
          results: state.results,
          scrollController: scrollController,
        ),
        orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.query,
    Key? key,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: AppDimens.xxxc,
            right: AppDimens.xxxc,
            top: AppDimens.l,
            bottom: AppDimens.ml,
          ),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    AppVectorGraphics.emptySearchResults,
                    height: AppDimens.c,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  LocaleKeys.search_emptyResults.tr(args: [query]),
                  style: AppTypography.b2Bold,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.cubit,
    required this.results,
    required this.scrollController,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final SearchViewCubit cubit;
  final List<SearchResult> results;
  final ScrollController scrollController;
  final bool withLoader;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.l),
          sliver: SliverAlignedGrid.count(
            crossAxisCount: _gridColumnCount,
            mainAxisSpacing: AppDimens.l,
            crossAxisSpacing: AppDimens.l,
            itemCount: results.length,
            itemBuilder: (context, index) {
              return results[index].mapOrNull(
                article: (data) => ArticleCover.explore(
                  article: data.article,
                  onTap: () => context.navigateToArticle(data.article),
                  coverColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
                ),
                topic: (data) => TopicCover.exploreSmall(
                  topic: data.topicPreview,
                  onTap: () => context.navigateToTopic(data.topicPreview),
                  hasBackgroundColor: false,
                ),
              );
            },
          ),
        ),
        if (withLoader)
          const SliverPadding(
            padding: EdgeInsets.all(AppDimens.xl),
            sliver: SliverToBoxAdapter(
              child: Loader(
                color: AppColors.limeGreen,
              ),
            ),
          ),
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

  void navigateToTopic(TopicPreview topicPreview) {
    pushRoute(
      TopicPage(
        topicSlug: topicPreview.slug,
      ),
    );
  }
}
