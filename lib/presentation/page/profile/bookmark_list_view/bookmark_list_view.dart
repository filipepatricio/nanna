import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_sort_view.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_list_tile.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_tile_cover.dt.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_empty_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnSortConfigChanged = Function(BookmarkSortConfigName configName);

class BookmarkListView extends HookWidget {
  BookmarkListView({
    required this.filter,
    required this.sortConfigName,
    required this.onSortConfigChanged,
    Key? key,
  })  : sortConfig = bookmarkConfigMap[sortConfigName]!,
        super(key: key);

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
      ],
    );
    final state = useCubitBuilder(cubit);

    final scrollController = useScrollController();
    final snackbarController = useMemoized(() => SnackbarController());

    useCubitListener<BookmarkListViewCubit, BookmarkListViewState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        bookmarkRemoved: (state) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: tr(LocaleKeys.bookmark_unbookmarkSuccess),
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
        cubit.initialize(
          filter,
          sortConfig.sort,
          sortConfig.order,
        );
      },
      [cubit],
    );

    return SnackbarParentView(
      controller: snackbarController,
      child: NextPageLoadExecutor(
        enabled: state.shouldListen,
        onNextPageLoad: cubit.loadNextPage,
        scrollController: scrollController,
        child: state.maybeMap(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SelectedSortConfig(
                onSortConfigChanged: onSortConfigChanged,
                config: sortConfig,
                enabled: false,
              ),
              const Expanded(
                child: Loader(
                  color: AppColors.limeGreen,
                ),
              ),
            ],
          ),
          empty: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SelectedSortConfig(
                onSortConfigChanged: onSortConfigChanged,
                config: sortConfig,
                enabled: false,
              ),
              Expanded(
                child: ProfileEmptyPage(filter: filter),
              ),
            ],
          ),
          idle: (state) => _Idle(
            cubit: cubit,
            bookmarks: state.bookmarks,
            sortConfig: sortConfig,
            scrollController: scrollController,
            onSortConfigChanged: onSortConfigChanged,
          ),
          loadMore: (state) => _Idle(
            cubit: cubit,
            bookmarks: state.bookmarks,
            sortConfig: sortConfig,
            scrollController: scrollController,
            onSortConfigChanged: onSortConfigChanged,
            withLoader: true,
          ),
          allLoaded: (state) => _Idle(
            cubit: cubit,
            bookmarks: state.bookmarks,
            sortConfig: sortConfig,
            scrollController: scrollController,
            onSortConfigChanged: onSortConfigChanged,
          ),
          orElse: () => const SizedBox.shrink(),
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
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final BookmarkListViewCubit cubit;
  final List<BookmarkTileCover> bookmarks;
  final BookmarkSortConfig sortConfig;
  final ScrollController scrollController;
  final bool withLoader;
  final OnSortConfigChanged onSortConfigChanged;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          expandedHeight: sortViewHeight,
          collapsedHeight: 0,
          toolbarHeight: 0,
          flexibleSpace: _SelectedSortConfig(
            onSortConfigChanged: onSortConfigChanged,
            enabled: bookmarks.length > 1,
            config: sortConfig,
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
                bookmarkCover: bookmarks[index],
                onRemoveBookmarkPressed: (bookmark) {
                  cubit.removeBookmark(bookmark);
                },
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
        const SliverPadding(
          padding: EdgeInsets.only(
            bottom: AppDimens.audioBannerHeight,
          ),
        ),
      ],
    );
  }
}

class _SelectedSortConfig extends StatelessWidget {
  const _SelectedSortConfig({
    required this.onSortConfigChanged,
    required this.config,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  final OnSortConfigChanged onSortConfigChanged;
  final BookmarkSortConfig config;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BookmarkSortView(
      config: enabled ? config : null,
      onSortConfigChange: (newConfig) {
        onSortConfigChanged(newConfig);
      },
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
