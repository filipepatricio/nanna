import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/items_grid_view/items_grid_view.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/fixed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategoryPage extends HookWidget {
  const CategoryPage({
    required this.category,
    Key? key,
  }) : super(key: key);
  final Category category;

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
                withPagination: (state) => ItemsGridView(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) => itemBuilder(context, index, state.items),
                  scrollController: scrollController,
                ),
                loadingMore: (state) => ItemsGridView(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) => itemBuilder(context, index, state.items),
                  scrollController: scrollController,
                  withLoader: true,
                ),
                allLoaded: (state) => ItemsGridView(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) => itemBuilder(context, index, state.items),
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

  Widget? itemBuilder(
    BuildContext context,
    int index,
    List<CategoryItem> items,
  ) =>
      items[index].mapOrNull(
        article: (data) => ArticleCover.exploreCarousel(
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
