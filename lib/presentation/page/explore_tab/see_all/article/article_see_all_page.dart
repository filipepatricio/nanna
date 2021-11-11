import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_section/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/article_see_all_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/article_see_all_page_state.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _itemHeight = 250.0;

class ArticleSeeAllPage extends HookWidget {
  final String sectionId;
  final String title;
  final List<MediaItemArticle> entries;

  const ArticleSeeAllPage({
    required this.sectionId,
    required this.title,
    required this.entries,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<ArticleSeeAllPageCubit>();
    final state = useCubitBuilder<ArticleSeeAllPageCubit, ArticleSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(sectionId));

    useEffect(() {
      cubit.initialize(sectionId, entries);
    }, [cubit]);

    final shouldListen = state.maybeMap(
      withPagination: (_) => true,
      orElse: () => false,
    );
    final screenHeight = MediaQuery.of(context).size.height;
    useEffect(() {
      final listener = shouldListen
          ? () {
              final position = scrollController.position;

              if (position.maxScrollExtent - position.pixels < (screenHeight / 2)) {
                cubit.loadNextPage();
              }
            }
          : () {};
      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController, shouldListen]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: false,
        elevation: 0,
        title: Text(
          tr(LocaleKeys.explore_title),
          style: AppTypography.h3bold,
        ),
        leading: IconButton(
          onPressed: () => AutoRouter.of(context).pop(),
          icon: RotatedBox(
            quarterTurns: 2,
            child: SvgPicture.asset(
              AppVectorGraphics.arrowRight,
              height: AppDimens.backArrowSize,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      body: _Body(
        title: title,
        state: state,
        scrollController: scrollController,
        pageStorageKey: pageStorageKey,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String title;
  final ArticleSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;

  const _Body({
    required this.title,
    required this.state,
    required this.scrollController,
    required this.pageStorageKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      loading: (_) => const Loader(),
      withPagination: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: false,
      ),
      loadingMore: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: true,
      ),
      allLoaded: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: false,
      ),
      orElse: () => const SizedBox(),
    );
  }
}

class _ArticleGrid extends StatelessWidget {
  final String title;
  final PageStorageKey pageStorageKey;
  final List<MediaItemArticle> articles;
  final ScrollController scrollController;
  final bool withLoader;

  const _ArticleGrid({
    required this.title,
    required this.pageStorageKey,
    required this.articles,
    required this.scrollController,
    required this.withLoader,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      key: pageStorageKey,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              const SizedBox(height: AppDimens.xc),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: InformedMarkdownBody(
                  markdown: title,
                  highlightColor: AppColors.transparent,
                  baseTextStyle: AppTypography.h1,
                ),
              ),
              const SizedBox(height: AppDimens.m),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _GridItem(article: articles[index]),
              childCount: articles.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: _itemHeight,
              crossAxisSpacing: AppDimens.m,
              mainAxisSpacing: AppDimens.xl,
            ),
          ),
        ),
        SeeAllLoadMoreIndicator(show: withLoader),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  final MediaItemArticle article;

  const _GridItem({
    required this.article,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ArticleListItem(
          article: article,
          themeColor: AppColors.background,
          height: _itemHeight,
          width: null,
        );
      },
    );
  }
}
