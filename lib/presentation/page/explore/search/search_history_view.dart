import 'package:better_informed_mobile/presentation/page/explore/explore_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/search/search_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class SearchHistoryView extends HookWidget {
  const SearchHistoryView({
    required this.explorePageCubit,
    required this.searchViewCubit,
    required this.searchHistory,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final ExplorePageCubit explorePageCubit;
  final SearchViewCubit searchViewCubit;
  final List<String> searchHistory;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppDimens.pageHorizontalMargin),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final query = searchHistory[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.xl),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        explorePageCubit.searchHistoryQueryTapped(query);
                      },
                      child: Container(
                        color: AppColors.transparent,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppVectorGraphics.search,
                              color: AppColors.textPrimary,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                              child: Text(
                                query,
                                style: AppTypography.b2Regular.copyWith(height: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.s),
                  ExpandTapWidget(
                    onTap: () => explorePageCubit.removeSearchHistoryQuery(query),
                    tapPadding: const EdgeInsets.all(AppDimens.s),
                    child: SvgPicture.asset(AppVectorGraphics.close),
                  ),
                ],
              ),
            );
          },
          childCount: searchHistory.length,
        ),
      ),
    );
  }
}
