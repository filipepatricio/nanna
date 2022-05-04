import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/page/search/search_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/debouncer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class SearchPage extends HookWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        actions: [
          Container(
            width: 65,
            margin: const EdgeInsets.only(right: AppDimens.m),
            child: TextButton(
              onPressed: () {
                AutoRouter.of(context).pop();
              },
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                LocaleKeys.common_cancel.tr(),
                style: AppTypography.subH1Medium.copyWith(
                  color: AppColors.darkGreyBackground,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
        title: const _SearchBar(),
      ),
    );
  }
}

class _SearchBar extends HookWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SearchPageCubit>();
    final searchController = useTextEditingController();
    final query = useState('');
    final debouncer = Debouncer(milliseconds: 2000);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useEffect(
      () {
        final listener = () {
          query.value = searchController.text;
          debouncer.run(() => cubit.search(query.value));
        };
        searchController.addListener(listener);
        return () => searchController.removeListener(listener);
      },
      [cubit, searchController],
    );

    return Container(
      height: AppDimens.searchBarHeight,
      margin: const EdgeInsets.only(left: AppDimens.s),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.textGrey,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: searchController,
        autofocus: true,
        cursorHeight: AppDimens.m,
        cursorColor: AppColors.darkGreyBackground,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: LocaleKeys.common_search.tr(),
          hintStyle: AppTypography.h4Medium.copyWith(
            color: AppColors.textGrey,
            height: 1.23,
          ),
          prefixIcon: SvgPicture.asset(
            AppVectorGraphics.search,
            color: AppColors.darkGreyBackground,
            fit: BoxFit.scaleDown,
          ),
          suffixIcon: query.value.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchController.text = '';
                  },
                  child: SvgPicture.asset(
                    AppVectorGraphics.close,
                    color: AppColors.darkGreyBackground,
                    height: AppDimens.xs,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : const SizedBox(),
        ),
        style: AppTypography.h4Medium.copyWith(
          color: AppColors.darkGreyBackground,
          height: 1.3,
        ),
      ),
    );
  }
}
