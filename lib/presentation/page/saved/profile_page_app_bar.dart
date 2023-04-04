part of 'saved_page.dart';

class _SavedPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SavedPageAppBar({
    required this.tabController,
    required this.cubit,
    required this.state,
    this.isConnected = true,
  });

  final TabController tabController;
  final SavedPageCubit cubit;
  final SavedPageState state;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: AppDimens.zero,
      title: SavedFilterTabBar(
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
      bottom: isConnected ? null : const NoConnectionBanner(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (isConnected ? 0 : NoConnectionBanner.height),
      );
}
