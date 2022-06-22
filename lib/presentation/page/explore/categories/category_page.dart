import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/results/results_idle_view.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/fixed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategoryPage extends HookWidget {
  final Category category;

  const CategoryPage({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<CategoryPageCubit>();
    final state = useCubitBuilder<CategoryPageCubit, CategoryPageState>(cubit);

    useEffect(
      () {
        cubit.initialize(category.slug, category.items);
      },
      [cubit],
    );

    final shouldListen = state.maybeMap(
      withPagination: (_) => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: FixedAppBar(scrollController: scrollController, title: category.name),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          NextPageLoadExecutor(
            enabled: shouldListen,
            onNextPageLoad: cubit.loadNextPage,
            scrollController: scrollController,
            child: TabBarListener(
              currentPage: context.routeData,
              scrollController: scrollController,
              child: state.maybeMap(
                loading: (_) => const SliverToBoxAdapter(child: Loader()),
                withPagination: (state) => ResultsIdleView(
                  items: state.items,
                  scrollController: scrollController,
                ),
                loadingMore: (state) => ResultsIdleView(
                  items: state.items,
                  scrollController: scrollController,
                  withLoader: true,
                ),
                allLoaded: (state) => ResultsIdleView(
                  items: state.items,
                  scrollController: scrollController,
                ),
                orElse: () => const SliverToBoxAdapter(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: AudioPlayerBannerPlaceholder(),
          ),
        ],
      ),
    );
  }
}
