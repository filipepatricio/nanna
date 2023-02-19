part of 'profile_page.dart';

class _ProfilePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfilePageAppBar({
    required this.tabController,
    required this.cubit,
    required this.state,
    this.isConnected = true,
  });

  final TabController tabController;
  final ProfilePageCubit cubit;
  final ProfilePageState state;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      bottom: isConnected ? null : const NoConnectionBanner(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (isConnected ? 0 : NoConnectionBanner.height),
      );
}
