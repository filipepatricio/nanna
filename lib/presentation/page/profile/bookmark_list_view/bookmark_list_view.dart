import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_cubit.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_list_tile.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_empty_page.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
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
    final cubit = useCubit<BookmarkListViewCubit>([filter]);
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize(
          filter,
          BookmarkSort.updated,
          BookmarkOrder.ascending,
        );
      },
      [filter, cubit],
    );

    return state.map(
      initial: (_) => const SizedBox.shrink(),
      loading: (_) => const Loader(),
      empty: (_) => ProfileEmptyPage(filter: filter),
      idle: (state) => _Idle(bookmarks: state.bookmarks),
      loadMore: (state) => _Idle(bookmarks: state.bookmarks),
      allLoaded: (state) => _Idle(bookmarks: state.bookmarks),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.bookmarks,
    Key? key,
  }) : super(key: key);

  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
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
      ],
    );
  }
}
