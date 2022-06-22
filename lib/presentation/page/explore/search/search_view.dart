import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/results/results_idle_view.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

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
            child: Loader(
              color: AppColors.limeGreen,
            ),
          ),
        ),
        empty: (state) => SliverToBoxAdapter(
          child: _EmptyView(query: state.query),
        ),
        idle: (state) => ResultsIdleView(
          items: state.results,
          scrollController: scrollController,
        ),
        loadMore: (state) => ResultsIdleView(
          items: state.results,
          scrollController: scrollController,
          withLoader: true,
        ),
        allLoaded: (state) => ResultsIdleView(
          items: state.results,
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
