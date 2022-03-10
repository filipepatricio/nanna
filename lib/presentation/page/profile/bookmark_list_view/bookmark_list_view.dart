import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_cubit.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_sort_view.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_list_tile.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_empty_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BookmarkListView extends HookWidget {
  const BookmarkListView({
    required this.filter,
    Key? key,
  }) : super(key: key);

  final BookmarkFilter filter;

  @override
  Widget build(BuildContext context) {
    final sortConfigState = useState(
      const BookmarkSortConfig(
        BookmarkSort.added,
        BookmarkOrder.descending,
      ),
    );
    final cubit = useCubit<BookmarkListViewCubit>(
      keys: [
        filter,
        sortConfigState.value,
      ],
    );
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();

    useEffect(
      () {
        cubit.initialize(
          filter,
          sortConfigState.value.sort,
          sortConfigState.value.order,
        );
      },
      [cubit],
    );

    return NextPageLoadExecutor(
      enabled: state.shouldListen,
      onNextPageLoad: cubit.loadNextPage,
      scrollController: scrollController,
      child: state.map(
        initial: (_) => const SizedBox.shrink(),
        loading: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SelectedSortConfig(
              configState: sortConfigState,
              enabled: true,
            ),
            const Expanded(
              child: Loader(),
            ),
          ],
        ),
        empty: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SelectedSortConfig(
              configState: sortConfigState,
              enabled: false,
            ),
            Expanded(
              child: ProfileEmptyPage(filter: filter),
            ),
          ],
        ),
        idle: (state) => _Idle(
          bookmarks: state.bookmarks,
          scrollController: scrollController,
          sortConfigState: sortConfigState,
        ),
        loadMore: (state) => _Idle(
          bookmarks: state.bookmarks,
          scrollController: scrollController,
          sortConfigState: sortConfigState,
          withLoader: true,
        ),
        allLoaded: (state) => _Idle(
          bookmarks: state.bookmarks,
          scrollController: scrollController,
          sortConfigState: sortConfigState,
        ),
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.bookmarks,
    required this.scrollController,
    required this.sortConfigState,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final List<Bookmark> bookmarks;
  final ScrollController scrollController;
  final bool withLoader;
  final ValueNotifier<BookmarkSortConfig> sortConfigState;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          expandedHeight: 60,
          collapsedHeight: 0,
          toolbarHeight: 0,
          flexibleSpace: _SelectedSortConfig(
            configState: sortConfigState,
            enabled: bookmarks.length > 1,
          ),
          pinned: false,
          floating: true,
          snap: true,
          primary: false,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return BookmarkListTile(
                bookmark: bookmarks[index],
              );
            },
            childCount: bookmarks.length,
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

class _SelectedSortConfig extends StatelessWidget {
  const _SelectedSortConfig({
    required this.configState,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<BookmarkSortConfig> configState;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.l,
      ),
      child: BookmarkSortView(
        config: enabled ? configState.value : null,
        onSortConfigChange: (newConfig) {
          return configState.value = newConfig;
        },
      ),
    );
  }
}

extension on BookmarkListViewState {
  bool get shouldListen {
    return maybeMap(
      idle: (_) => true,
      orElse: () => false,
    );
  }
}
