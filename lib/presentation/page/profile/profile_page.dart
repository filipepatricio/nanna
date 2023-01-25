import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_sort_view.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_filter_tab_bar.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ProfilePageCubit>();
    final state = useCubitBuilder(cubit);
    final tabController = useTabController(initialLength: 3);
    final scrollController = useScrollController();

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: AppDimens.zero,
        title: ProfileFilterTabBar(
          controller: tabController,
          onChange: cubit.changeFilter,
        ),
        leading: state.maybeMap(
          idle: (data) => Padding(
            padding: const EdgeInsets.only(left: AppDimens.s),
            child: BookmarkSortView(
              config: bookmarkConfigMap[data.sortConfigName]!,
              onSortConfigChange: (sortConfig) => cubit.changeSortConfig(sortConfig),
            ),
          ),
          orElse: Container.new,
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushRoute(const SettingsMainPageRoute()),
            icon: const InformedSvg(
              AppVectorGraphics.settings,
              fit: BoxFit.contain,
            ),
            splashRadius: AppDimens.l,
          ),
          const SizedBox(width: AppDimens.xs),
        ],
      ),
      body: TabBarListener(
        scrollController: scrollController,
        currentPage: context.routeData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: state.maybeMap(
                initializing: (state) => const BookmarkLoadingView(),
                idle: (state) => SnackbarParentView(
                  audioPlayerResponsive: true,
                  child: BookmarkListView(
                    key: ValueKey(state.version),
                    scrollController: scrollController,
                    filter: state.filter,
                    hasActiveSubscription: state.hasActiveSubscription,
                    sortConfigName: state.sortConfigName,
                    onSortConfigChanged: (sortConfig) => cubit.changeSortConfig(sortConfig),
                  ),
                ),
                orElse: Container.new,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
