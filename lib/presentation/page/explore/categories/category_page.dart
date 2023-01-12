import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/card_divider.dart';
import 'package:better_informed_mobile/presentation/widget/category_preference_follow_button/category_preference_follow_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_sliver_cupertino_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CategoryPage extends HookWidget {
  const CategoryPage({
    required this.category,
    required this.openedFrom,
    Key? key,
  }) : super(key: key);

  final CategoryWithItems category;
  final String openedFrom;

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

    return SnackbarParentView(
      child: Scaffold(
        body: CustomScrollView(
          physics: const BottomBouncingScrollPhysics(),
          controller: scrollController,
          slivers: [
            InformedSliverCupertinoAppBar(
              leading: BackTextButton(
                color: AppColors.light.textPrimary,
                text: openedFrom,
              ),
              title: category.name,
              expanded: Theme(
                data: Theme.of(context).copyWith(brightness: Brightness.light),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CategoryPreferenceFollowButton(
                    category: category,
                  ),
                ),
              ),
              backgroundColor: category.color,
              textColor: AppColors.light.textPrimary,
            ),
            NextPageLoadExecutor(
              enabled: shouldListen,
              onNextPageLoad: cubit.loadNextPage,
              scrollController: scrollController,
              child: TabBarListener(
                currentPage: context.routeData,
                scrollController: scrollController,
                child: state.maybeMap(
                  loading: (_) => const SliverToBoxAdapter(child: Loader()),
                  withPagination: (state) => _List(
                    items: state.items,
                  ),
                  loadingMore: (state) => _List(
                    items: state.items,
                    withLoader: true,
                  ),
                  allLoaded: (state) => _List(
                    items: state.items,
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
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.items,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final List<CategoryItem> items;
  final bool withLoader;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = items[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  item.map(
                    article: (data) => ArticleCover.medium(
                      article: data.article,
                      onTap: () => context.navigateToArticle(data.article),
                    ),
                    topic: (data) => TopicCover.medium(
                      topic: data.topicPreview,
                      onTap: () => context.navigateToTopic(data.topicPreview),
                    ),
                    unknown: (_) => const SizedBox.shrink(),
                  ),
                  item.maybeMap(
                    orElse: CardDivider.cover,
                    unknown: (_) => const SizedBox.shrink(),
                  ),
                ],
              );
            },
            childCount: items.length,
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

  void navigateToTopic(TopicPreview topicPreview) {
    pushRoute(
      TopicPage(
        topicSlug: topicPreview.slug,
      ),
    );
  }
}
