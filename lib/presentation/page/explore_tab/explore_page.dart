import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart' as article_image;
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_section/article_section_view.dart';
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

final mockedArticleList = [
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israel’s opposition has finally mustered a majority to dislodge Binyamin Netanyahu',
    type: ArticleType.premium,
    publicationDate: '2021-02-03',
    timeToRead: 5,
    publisher: Publisher(name: 'NYT', logo: article_image.Image(publicId: 'publishers/the_economist')),
    image: article_image.Image(publicId: 'articles/storm'),
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israels government: End of Netanyahu era?',
    type: ArticleType.premium,
    publicationDate: '2021-02-09',
    timeToRead: 3,
    publisher: Publisher(name: 'NYT', logo: article_image.Image(publicId: 'publishers/the_economist')),
    image: article_image.Image(publicId: 'articles/storm'),
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'China allows three children in major policy shift',
    type: ArticleType.premium,
    publicationDate: '2021-02-08',
    timeToRead: 6,
    publisher: Publisher(name: 'NYT', logo: article_image.Image(publicId: 'publishers/the_economist')),
    image: article_image.Image(publicId: 'articles/storm'),
  ),
];

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
                  idle: (state) => const _Idle(),
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
  const _Idle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ArticleSectionView(articles: mockedArticleList, backgroundColor: AppColors.limeGreen),
          const ReadingListSectionView(),
          ArticleSectionView(articles: mockedArticleList, backgroundColor: AppColors.pastelGreen),
        ],
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
            style: AppTypography.h0Bold,
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
