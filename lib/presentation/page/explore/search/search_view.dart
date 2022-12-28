import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/items_grid_view/items_grid_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
      enabled: state.maybeMap(
        idle: (_) => true,
        orElse: () => false,
      ),
      onNextPageLoad: cubit.loadNextPage,
      scrollController: scrollController,
      child: state.maybeMap(
        initial: (_) => const SliverToBoxAdapter(child: SizedBox.shrink()),
        loading: (_) => const SliverFillRemaining(
          child: Center(
            child: Loader(),
          ),
        ),
        empty: (state) => SliverToBoxAdapter(
          child: _EmptyView(query: state.query),
        ),
        idle: (state) => ItemsGridView(
          itemCount: state.results.length,
          itemBuilder: (context, index) => itemBuilder(context, index, state.results),
          scrollController: scrollController,
        ),
        loadMore: (state) => ItemsGridView(
          itemCount: state.results.length,
          itemBuilder: (context, index) => itemBuilder(context, index, state.results),
          scrollController: scrollController,
          withLoader: true,
        ),
        allLoaded: (state) => ItemsGridView(
          itemCount: state.results.length,
          itemBuilder: (context, index) => itemBuilder(context, index, state.results),
          scrollController: scrollController,
        ),
        orElse: () => const SliverToBoxAdapter(),
      ),
    );
  }

  Widget? itemBuilder(
    BuildContext context,
    int index,
    List<SearchResult> items,
  ) =>
      items[index].mapOrNull(
        article: (data) => ArticleCover.small(
          article: data.article,
          onTap: () => context.navigateToArticle(data.article),
        ),
        topic: (data) => TopicCover.small(
          topic: data.topicPreview,
          onTap: () => context.navigateToTopic(data.topicPreview),
        ),
      );
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
            top: AppDimens.xxxc,
            bottom: AppDimens.ml,
          ),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Center(
                  child: InformedSvg(
                    AppVectorGraphics.search,
                    height: AppDimens.xl,
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
