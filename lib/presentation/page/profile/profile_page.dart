import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/bookmark_list_view.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_filter_tab_bar.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ProfilePageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());
    final tabController = useTabController(initialLength: 3);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        titleSpacing: AppDimens.l,
        title: Text(
          LocaleKeys.profile_title.tr(),
          style: AppTypography.h1Bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
            child: IconButton(
              onPressed: () => AutoRouter.of(context).push(const SettingsMainPageRoute()),
              icon: SvgPicture.asset(
                AppVectorGraphics.settings,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: ReadingBannerWrapper(
        child: SnackbarParentView(
          controller: snackbarController,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileFilterTabBar(
                  controller: tabController,
                  onChange: cubit.changeFilter,
                ),
                Expanded(
                  child: state.map(
                    initializing: (state) => const Loader(
                      color: AppColors.limeGreen,
                    ),
                    idle: (state) => BookmarkListView(
                      filter: state.filter,
                      sortConfigName: state.sortConfigName,
                      onSortConfigChanged: (sortConfig) => cubit.changeSortConfig(sortConfig),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
