import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';

class SliverSearchAppBar extends StatelessWidget {
  const SliverSearchAppBar({
    required this.explorePageCubit,
    required this.searchTextEditingController,
    required this.searchViewCubit,
    Key? key,
  }) : super(key: key);

  final ExplorePageCubit explorePageCubit;
  final TextEditingController searchTextEditingController;
  final SearchViewCubit searchViewCubit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shadowColor: AppColors.black40,
      pinned: true,
      centerTitle: false,
      elevation: 1.0,
      expandedHeight: AppDimens.appBarHeight,
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
    );
  }
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
    final searchTextFieldFocusNode = useFocusNode();

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
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppDimens.xs),
      ),
      child: TextFormField(
        controller: searchTextEditingController,
        autofocus: false,
        focusNode: searchTextFieldFocusNode,
        cursorHeight: AppDimens.sl,
        cursorColor: AppColors.charcoal,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: LocaleKeys.common_search.tr(),
          hintStyle: AppTypography.b2Medium.copyWith(
            color: AppColors.textGrey,
            height: 1.05,
          ),
          prefixIcon: SvgPicture.asset(
            AppVectorGraphics.search,
            color: AppColors.charcoal,
            fit: BoxFit.scaleDown,
          ),
          suffixIcon: query.value.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchTextEditingController.clear();
                    FocusScope.of(context).requestFocus(searchTextFieldFocusNode);
                  },
                  child: SvgPicture.asset(
                    AppVectorGraphics.clearText,
                    height: AppDimens.xs,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        style: AppTypography.b2Medium.copyWith(
          color: AppColors.charcoal,
          height: 1,
        ),
        onFieldSubmitted: (query) {
          if (searchViewCubit.shouldTriggerSearch(query)) {
            searchViewCubit.submitSearchPhrase(query);
            explorePageCubit.search();
          }
        },
        onTap: explorePageCubit.startTyping,
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
                    LocaleKeys.common_cancel.tr(),
                    style: AppTypography.h4Medium.copyWith(
                      color: AppColors.textGrey,
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
