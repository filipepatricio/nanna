import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_section/article_section_view.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_section/article_with_cover_section_view.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/reading_list_section/reading_list_section_view.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _topMargin = 80.0;

class ExplorePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ExplorePageCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return CupertinoScaffold(
      body: ReadingBannerWrapper(
        child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const _Header(),
                    ],
                  ),
                ),
                state.maybeMap(
                  initialLoading: (_) => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimens.l),
                      child: Loader(),
                    ),
                  ),
                  idle: (state) => _Idle(sections: state.sections),
                  orElse: () => const SliverToBoxAdapter(
                    child: SizedBox(),
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

class _Idle extends StatelessWidget {
  final List<ExploreContentSection> sections;

  const _Idle({
    required this.sections,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        sections.map((section) => _Section(section: section)).toList(growable: false),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.limeGreen,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: _topMargin),
          Text(
            LocaleKeys.main_exploreTab.tr(),
            style: AppTypography.hBold,
          ),
          const SizedBox(height: AppDimens.l),
          TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.xl),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.xl),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.xl),
              ),
              hintText: tr(LocaleKeys.common_search),
              hintStyle: AppTypography.h3Normal,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: AppDimens.l, right: AppDimens.m),
                child: SvgPicture.asset(
                  AppVectorGraphics.search,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final ExploreContentSection section;

  const _Section({
    required this.section,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return section.map(
      articles: (section) => ArticleSectionView(section: section),
      articleWithCover: (section) => ArticleWithCoverSectionView(section: section),
      readingLists: (section) => ReadingListSectionView(section: section),
    );
  }
}
