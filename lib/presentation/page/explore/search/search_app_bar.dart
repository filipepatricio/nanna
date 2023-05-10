import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/intl_util.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/no_connection_banner/no_connection_banner.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    required this.explorePageCubit,
    required this.searchTextEditingController,
    required this.searchViewCubit,
    this.isConnected = true,
    Key? key,
  }) : super(key: key);

  final ExplorePageCubit explorePageCubit;
  final TextEditingController searchTextEditingController;
  final SearchViewCubit searchViewCubit;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      titleSpacing: AppDimens.pageHorizontalMargin,
      actions: [
        _CancelButton(
          cubit: explorePageCubit,
          searchTextEditingController: searchTextEditingController,
        ),
      ],
      title: _SearchBar(
        explorePageCubit: explorePageCubit,
        searchViewCubit: searchViewCubit,
        searchTextEditingController: searchTextEditingController,
      ),
      bottom: isConnected ? null : const NoConnectionBanner(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (isConnected ? 0 : NoConnectionBanner.height),
      );
}

class _SearchBar extends HookWidget {
  const _SearchBar({
    required this.explorePageCubit,
    required this.searchViewCubit,
    required this.searchTextEditingController,
    Key? key,
  }) : super(key: key);

  final ExplorePageCubit explorePageCubit;
  final SearchViewCubit searchViewCubit;
  final TextEditingController searchTextEditingController;

  @override
  Widget build(BuildContext context) {
    final query = useState('');
    final exploreState = useCubitBuilder(explorePageCubit);
    final searchTextFieldFocusNode = useFocusNode();
    final snackbarController = useSnackbarController();

    useEffect(
      () {
        void listener() {
          query.value = searchTextEditingController.text;
          searchViewCubit.search(query.value);
          if (searchViewCubit.shouldTriggerSearch(query.value)) {
            explorePageCubit.search();
          } else {
            explorePageCubit.startTyping();
          }
        }

        searchTextEditingController.addListener(listener);
        return () => searchTextEditingController.removeListener(listener);
      },
      [searchViewCubit, searchTextEditingController],
    );

    useEffect(
      () {
        void listener() {
          if (!searchTextFieldFocusNode.hasFocus) {
            if (searchViewCubit.shouldTriggerSearch(query.value)) {
              searchViewCubit.submitSearchPhrase(query.value);
            }
          }
        }

        searchTextFieldFocusNode.addListener(listener);
        return () => searchTextFieldFocusNode.removeListener(listener);
      },
      [searchViewCubit, searchTextFieldFocusNode],
    );

    return Container(
      height: AppDimens.searchBarHeight,
      decoration: BoxDecoration(
        color: AppColors.of(context).backgroundSecondary,
        borderRadius: BorderRadius.circular(AppDimens.xs),
      ),
      child: TextFormField(
        controller: searchTextEditingController,
        autofocus: false,
        focusNode: searchTextFieldFocusNode,
        cursorHeight: AppDimens.sl,
        cursorColor: AppColors.of(context).textPrimary,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: context.l10n.search_hint,
          hintStyle: AppTypography.b2Medium.copyWith(
            color: AppColors.of(context).textSecondary,
            height: 1.05,
          ),
          prefixIcon: InformedSvg(
            AppVectorGraphics.search,
            color: Theme.of(context).iconTheme.color,
            fit: BoxFit.scaleDown,
          ),
          suffixIcon: query.value.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchTextEditingController.clear();
                    FocusScope.of(context).requestFocus(searchTextFieldFocusNode);
                  },
                  child: InformedSvg(
                    AppVectorGraphics.clearText,
                    color: AppColors.of(context).textSecondary,
                    height: AppDimens.xs,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        style: AppTypography.b2Medium.copyWith(height: 1),
        onFieldSubmitted: (query) {
          if (searchViewCubit.shouldTriggerSearch(query)) {
            searchViewCubit.submitSearchPhrase(query);
            explorePageCubit.search();
          }
        },
        onTap: () => exploreState.maybeMap(
          idleGuest: (_) {
            searchTextFieldFocusNode.unfocus();
            snackbarController.showMessage(
              SnackbarMessage.guest(context),
            );
          },
          orElse: explorePageCubit.startTyping,
        ),
      ),
    );
  }
}

class _CancelButton extends HookWidget {
  const _CancelButton({
    required this.cubit,
    required this.searchTextEditingController,
    Key? key,
  }) : super(key: key);

  final ExplorePageCubit cubit;
  final TextEditingController searchTextEditingController;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);
    return KeyboardVisibilityBuilder(
      builder: (context, visible) => Container(
        child: visible ||
                state.maybeMap(
                  search: (_) => true,
                  searchHistory: (_) => true,
                  orElse: () => false,
                )
            ? Container(
                margin: const EdgeInsets.only(right: AppDimens.pageHorizontalMargin),
                child: TextButton(
                  onPressed: () {
                    searchTextEditingController.clear();
                    Future.delayed(Duration.zero, () {
                      cubit.explore();
                    });
                    final currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Text(
                    context.l10n.common_cancel,
                    style: AppTypography.h4Medium.copyWith(
                      color: AppColors.of(context).textSecondary,
                      height: 1.1,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
