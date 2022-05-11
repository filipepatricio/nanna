import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliver_tools/sliver_tools.dart';

const _aspectRatio = 0.8;
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
    scrollController.jumpTo(0);

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
              // Expanded(
              //   flex: 1,
              //   child: Center(
              //     child: Text(
              //       LocaleKeys.search_callToAction.tr(),
              //       style: AppTypography.b2Regular,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
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
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridColumnCount,
            childAspectRatio: _aspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return results[index].mapOrNull(
                article: (data) => LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArticleListItem(
                          article: data.article,
                          themeColor: AppColors.background,
                          cardColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
                          height: constraints.maxHeight * 0.9,
                          width: constraints.maxWidth * 0.85,
                        ),
                      ],
                    );
                  },
                ),
                topic: (data) => LayoutBuilder(
                  builder: (context, constraints) {
                    return StackedCards.variant(
                      variant: StackedCardsVariant.values[index % StackedCardsVariant.values.length],
                      coverSize: Size(
                        constraints.maxWidth * 0.85,
                        constraints.maxHeight * 0.9,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).push(
                            TopicPage(
                              topicSlug: data.topicPreview.slug,
                            ),
                          );
                        },
                        child: TopicCover.small(
                          topic: data.topicPreview,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            childCount: results.length,
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
        const SliverPadding(
          padding: EdgeInsets.only(
            bottom: AppDimens.audioBannerHeight,
          ),
        ),
      ],
    );
  }
}
