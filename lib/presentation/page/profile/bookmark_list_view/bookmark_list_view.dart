import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_list_tile.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_empty_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

typedef OnSortConfigChanged = Function(BookmarkSortConfigName configName);

class BookmarkListView extends HookWidget {
  BookmarkListView({
    required this.filter,
    required this.sortConfigName,
    required this.onSortConfigChanged,
    required this.scrollController,
    Key? key,
  })  : sortConfig = bookmarkConfigMap[sortConfigName]!,
        super(key: key);

  final ScrollController scrollController;
  final BookmarkFilter filter;
  final BookmarkSortConfigName sortConfigName;
  final BookmarkSortConfig sortConfig;
  final OnSortConfigChanged onSortConfigChanged;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<BookmarkListViewCubit>(
      keys: [
        filter,
        sortConfig,
        key,
      ],
    );
    final state = useCubitBuilder(cubit);

    final snackbarController = useMemoized(() => SnackbarController(audioPlayerResponsive: true));

    useCubitListener<BookmarkListViewCubit, BookmarkListViewState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        bookmarkRemoved: (state) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: tr(LocaleKeys.bookmark_removeBookmarkSuccess),
              type: SnackbarMessageType.positive,
              action: SnackbarAction(
                label: tr(LocaleKeys.common_undo),
                callback: () {
                  cubit.undoRemovingBookmark(state.bookmark, state.index);
                },
              ),
            ),
          );
        },
      );
    });

    useEffect(
      () {
        cubit.initialize(filter, sortConfig.sort, sortConfig.order);
      },
      [cubit],
    );

    return VisibilityDetector(
      onVisibilityChanged: (_) {
        snackbarController.discardMessage();
      },
      key: const Key('bookmark_list'),
      child: SnackbarParentView(
        controller: snackbarController,
        child: NextPageLoadExecutor(
          enabled: state.shouldListen,
          onNextPageLoad: cubit.loadNextPage,
          scrollController: scrollController,
          child: InformedAnimatedSwitcher(
            child: state.maybeMap(
              initial: (_) => const SizedBox.shrink(),
              loading: (_) => const Center(
                child: Loader(
                  color: AppColors.neutralGrey,
                ),
              ),
              empty: (_) => ProfileEmptyPage(filter: filter),
              idle: (state) => _Idle(
                cubit: cubit,
                bookmarks: state.bookmarks,
                sortConfig: sortConfig,
                scrollController: scrollController,
                onSortConfigChanged: onSortConfigChanged,
                snackbarController: snackbarController,
              ),
              loadMore: (state) => _Idle(
                cubit: cubit,
                bookmarks: state.bookmarks,
                sortConfig: sortConfig,
                scrollController: scrollController,
                onSortConfigChanged: onSortConfigChanged,
                snackbarController: snackbarController,
                withLoader: true,
              ),
              allLoaded: (state) => _Idle(
                cubit: cubit,
                bookmarks: state.bookmarks,
                sortConfig: sortConfig,
                scrollController: scrollController,
                onSortConfigChanged: onSortConfigChanged,
                snackbarController: snackbarController,
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.cubit,
    required this.bookmarks,
    required this.sortConfig,
    required this.scrollController,
    required this.onSortConfigChanged,
    required this.snackbarController,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final BookmarkListViewCubit cubit;
  final List<Bookmark> bookmarks;
  final BookmarkSortConfig sortConfig;
  final ScrollController scrollController;
  final bool withLoader;
  final OnSortConfigChanged onSortConfigChanged;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => BookmarkListTile(
              key: Key(bookmarks[index].id),
              bookmark: bookmarks[index],
              onRemoveBookmarkPressed: (bookmark) {
                cubit.removeBookmark(bookmark);
              },
              snackbarController: snackbarController,
              cubit: cubit,
            ),
            childCount: bookmarks.length,
          ),
        ),
        if (withLoader)
          const SliverPadding(
            padding: EdgeInsets.all(AppDimens.xl),
            sliver: SliverToBoxAdapter(
              child: Loader(
                color: AppColors.neutralGrey,
              ),
            ),
          ),
        const SliverToBoxAdapter(
          child: AudioPlayerBannerPlaceholder(),
        ),
      ],
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
