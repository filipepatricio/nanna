import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/free_user_banner.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_list_tile.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/card_divider.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'bookmark_empty_page.dart';

typedef OnSortConfigChanged = Function(BookmarkSortConfigName configName);

class BookmarkListView extends HookWidget {
  BookmarkListView({
    required this.filter,
    required this.sortConfigName,
    required this.onSortConfigChanged,
    required this.scrollController,
    required this.hasActiveSubscription,
    Key? key,
  })  : sortConfig = bookmarkConfigMap[sortConfigName]!,
        super(key: key);

  final ScrollController scrollController;
  final BookmarkFilter filter;
  final BookmarkSortConfigName sortConfigName;
  final BookmarkSortConfig sortConfig;
  final OnSortConfigChanged onSortConfigChanged;
  final bool hasActiveSubscription;

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

    final snackbarController = useSnackbarController();

    useCubitListener<BookmarkListViewCubit, BookmarkListViewState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        bookmarkRemoved: (state) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: tr(LocaleKeys.bookmark_removeBookmarkSuccess),
              type: SnackbarMessageType.success,
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
      child: NextPageLoadExecutor(
        enabled: state.shouldListen,
        onNextPageLoad: cubit.loadNextPage,
        scrollController: scrollController,
        child: InformedAnimatedSwitcher(
          child: state.maybeMap(
            initial: (_) => const SizedBox.shrink(),
            error: (_) => Center(
              child: GeneralErrorView(
                title: LocaleKeys.common_error_title.tr(),
                content: LocaleKeys.common_error_body.tr(),
                retryCallback: cubit.loadNextPage,
              ),
            ),
            loading: (_) => BookmarkLoadingView(hasActiveSubscription: hasActiveSubscription),
            empty: (state) => _BookmarkEmptyView(
              hasActiveSubscription: hasActiveSubscription,
              filter: filter,
            ),
            idle: (state) => _Idle(
              cubit: cubit,
              bookmarks: state.bookmarks,
              sortConfig: sortConfig,
              scrollController: scrollController,
              onSortConfigChanged: onSortConfigChanged,
              hasActiveSubscription: hasActiveSubscription,
            ),
            loadMore: (state) => _Idle(
              cubit: cubit,
              bookmarks: state.bookmarks,
              sortConfig: sortConfig,
              scrollController: scrollController,
              onSortConfigChanged: onSortConfigChanged,
              hasActiveSubscription: hasActiveSubscription,
              withLoader: true,
            ),
            allLoaded: (state) => _Idle(
              cubit: cubit,
              bookmarks: state.bookmarks,
              sortConfig: sortConfig,
              scrollController: scrollController,
              onSortConfigChanged: onSortConfigChanged,
              hasActiveSubscription: hasActiveSubscription,
            ),
            orElse: () => const SizedBox.shrink(),
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
    required this.hasActiveSubscription,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final BookmarkListViewCubit cubit;
  final List<Bookmark> bookmarks;
  final BookmarkSortConfig sortConfig;
  final ScrollController scrollController;
  final bool withLoader;
  final OnSortConfigChanged onSortConfigChanged;
  final bool hasActiveSubscription;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        if (!hasActiveSubscription)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
              child: FreeUserBanner(),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Column(
              children: [
                BookmarkListTile(
                  key: Key(bookmarks[index].id),
                  bookmark: bookmarks[index],
                  onRemoveBookmarkPressed: (bookmark) {
                    cubit.removeBookmark(bookmark);
                  },
                  cubit: cubit,
                ),
                if (index != (bookmarks.length - 1)) const CardDivider.cover()
              ],
            ),
            childCount: bookmarks.length,
          ),
        ),
        if (withLoader)
          const SliverPadding(
            padding: EdgeInsets.all(AppDimens.xl),
            sliver: SliverToBoxAdapter(
              child: Loader(),
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
