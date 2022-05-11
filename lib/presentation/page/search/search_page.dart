import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/search/search_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _aspectRatio = 0.8;
const _gridColumnCount = 2;

class SearchPage extends HookWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SearchPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());
    final scrollController = useScrollController();

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
        actions: [
          Container(
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
                style: AppTypography.h4Bold.copyWith(
                  color: AppColors.darkGreyBackground,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
        title: _SearchBar(cubit: cubit),
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: NextPageLoadExecutor(
          enabled: true,
          onNextPageLoad: cubit.loadNextPage,
          scrollController: scrollController,
          child: state.maybeMap(
            initial: (_) => const SizedBox.shrink(),
            loading: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(
                  child: Loader(
                    color: AppColors.limeGreen,
                  ),
                ),
              ],
            ),
            empty: (state) => _EmptyView(query: state.query),
            idle: (state) => _Idle(
              cubit: cubit,
              results: state.results,
              scrollController: scrollController,
            ),
            loadMore: (state) => _Idle(
              cubit: cubit,
              results: state.results,
              scrollController: scrollController,
              withLoader: true,
            ),
            allLoaded: (state) => _Idle(
              cubit: cubit,
              results: state.results,
              scrollController: scrollController,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.query,
    Key? key,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: AppDimens.xxxc,
            right: AppDimens.xxxc,
            top: AppDimens.l,
            bottom: AppDimens.ml,
          ),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    AppVectorGraphics.emptySearchResults,
                    height: AppDimens.c,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  LocaleKeys.search_emptyResults.tr(args: [query]),
                  style: AppTypography.b2Bold,
                  textAlign: TextAlign.center,
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Center(
              //     child: Text(
              //       LocaleKeys.search_callToAction.tr(),
              //       style: AppTypography.b2Regular,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.cubit,
    required this.results,
    required this.scrollController,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final SearchPageCubit cubit;
  final List<SearchResult> results;
  final ScrollController scrollController;
  final bool withLoader;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridColumnCount,
            childAspectRatio: _aspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return results[index].mapOrNull(
                article: (data) => LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArticleListItem(
                          article: data.article,
                          themeColor: AppColors.background,
                          cardColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
                          height: constraints.maxHeight * 0.9,
                          width: constraints.maxWidth * 0.85,
                        ),
                      ],
                    );
                  },
                ),
                topic: (data) => LayoutBuilder(
                  builder: (context, constraints) {
                    return StackedCards.variant(
                      variant: StackedCardsVariant.values[index % StackedCardsVariant.values.length],
                      coverSize: Size(
                        constraints.maxWidth * 0.85,
                        constraints.maxHeight * 0.9,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).push(
                            TopicPage(
                              topicSlug: data.topicPreview.slug,
                            ),
                          );
                        },
                        child: TopicCover.small(
                          topic: data.topicPreview,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            childCount: results.length,
          ),
        ),
        if (withLoader)
          const SliverPadding(
            padding: EdgeInsets.all(AppDimens.xl),
            sliver: SliverToBoxAdapter(
              child: Loader(
                color: AppColors.limeGreen,
              ),
            ),
          ),
        const SliverPadding(
          padding: EdgeInsets.only(
            bottom: AppDimens.audioBannerHeight,
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends HookWidget {
  const _SearchBar({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final SearchPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final query = useState('');

    useEffect(
      () {
        final listener = () {
          query.value = searchController.text;
          cubit.search(query.value);
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
        textInputAction: TextInputAction.search,
        autocorrect: false,
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
                    AppVectorGraphics.clearText,
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
