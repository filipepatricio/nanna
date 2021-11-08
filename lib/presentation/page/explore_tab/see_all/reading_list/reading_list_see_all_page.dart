import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/reading_list/reading_list_see_all_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/reading_list/reading_list_see_all_page_state.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover_small.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _itemHeight = 320.0;

class ReadingListSeeAllPage extends HookWidget {
  final String sectionId;
  final String title;
  final List<Topic> topics;

  const ReadingListSeeAllPage({
    required this.sectionId,
    required this.title,
    required this.topics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<ReadingListSeeAllPageCubit>();
    final state = useCubitBuilder<ReadingListSeeAllPageCubit, ReadingListSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(sectionId));

    useEffect(() {
      cubit.initialize(sectionId, topics);
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
        pageStorageKey: pageStorageKey,
        scrollController: scrollController,
        state: state,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String title;
  final ReadingListSeeAllPageState state;
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
      withPagination: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        withLoader: false,
      ),
      loadingMore: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        withLoader: true,
      ),
      allLoaded: (state) => _TopicGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        topics: state.topics,
        scrollController: scrollController,
        withLoader: false,
      ),
      orElse: () => const SizedBox(),
    );
  }
}

class _TopicGrid extends StatelessWidget {
  final String title;
  final PageStorageKey pageStorageKey;
  final List<Topic> topics;
  final ScrollController scrollController;
  final bool withLoader;

  const _TopicGrid({
    required this.title,
    required this.pageStorageKey,
    required this.topics,
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
                child: Hero(
                  tag: HeroTag.exploreReadingListTitle(title.hashCode),
                  child: InformedMarkdownBody(
                    markdown: title,
                    highlightColor: AppColors.transparent,
                    baseTextStyle: AppTypography.h1,
                  ),
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
              (context, index) => _GridItem(topic: topics[index]),
              childCount: topics.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: _itemHeight,
              mainAxisSpacing: AppDimens.m,
            ),
          ),
        ),
        SeeAllLoadMoreIndicator(show: withLoader),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  final Topic topic;

  const _GridItem({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onReadingListTap(context, topic),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ReadingListStackedCards(
            coverSize: Size(constraints.maxWidth, _itemHeight),
            child: ReadingListCoverSmall(topic: topic),
          );
        },
      ),
    );
  }

  void _onReadingListTap(BuildContext context, Topic topic) {
    AutoRouter.of(context).push(
      SingleTopicPageRoute(
        topic: topic,
      ),
    );
  }
}
