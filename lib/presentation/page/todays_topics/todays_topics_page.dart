import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_state.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:better_informed_mobile/presentation/widget/scrollable_sliver_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'todays_topics_page_state.dart';

class TodaysTopicsPage extends HookWidget {
  const TodaysTopicsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TodaysTopicsPageCubit>();
    final state = useCubitBuilder(cubit);
    final controller = usePageController(viewportFraction: AppDimens.topicCardWidthViewportFraction);
    final relaxState = useState(false);
    final scrollController = useScrollController();
    final cardStackWidth = MediaQuery.of(context).size.width * AppDimens.topicCardWidthViewportFraction;
    final cardSectionMaxHeight = MediaQuery.of(context).size.height * 0.8;
    final cardStackHeight = MediaQuery.of(context).size.height * 0.65;

    useEffect(
      () {
        final listener = () {
          relaxState.value = state.maybeMap(
            idle: (state) {
              final topics = state.currentBrief.numberOfTopics;
              final offset = topics - (controller.page ?? 0);
              return topics > 0 && offset >= 0.0 && offset <= 0.5;
            },
            orElse: () => false,
          );
        };

        controller.addListener(listener);
        return () => controller.removeListener(listener);
      },
      [controller, state],
    );

    useCubitListener<TodaysTopicsPageCubit, TodaysTopicsPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) => Future.delayed(const Duration(milliseconds: 100), () {
          showToast(context, text);
        }),
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: RefreshIndicator(
          onRefresh: cubit.loadTodaysTopics,
          color: AppColors.darkGrey,
          child: NoScrollGlow(
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              slivers: [
                ScrollableSliverAppBar(
                  scrollController: scrollController,
                  title: LocaleKeys.todaysTopics_title.tr(),
                ),
                state.maybeMap(
                  idle: (state) => _IdleContent(
                    todaysTopicsCubit: cubit,
                    currentBrief: state.currentBrief,
                    controller: controller,
                    cardStackWidth: cardStackWidth,
                    cardStackHeight: cardStackHeight,
                  ),
                  error: (_) => SliverToBoxAdapter(
                    child: SizedBox(
                      height: cardSectionMaxHeight,
                      child: StackedCardsErrorView(
                        retryAction: cubit.loadTodaysTopics,
                        cardStackWidth: cardStackWidth,
                      ),
                    ),
                  ),
                  loading: (_) => SliverToBoxAdapter(
                    child: SizedBox(
                      height: cardSectionMaxHeight,
                      child: StackedCardsLoadingView(cardStackWidth: cardStackWidth),
                    ),
                  ),
                  orElse: () => const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  final TodaysTopicsPageCubit todaysTopicsCubit;
  final CurrentBrief currentBrief;
  final PageController controller;
  final double cardStackWidth;
  final double cardStackHeight;

  const _IdleContent({
    required this.todaysTopicsCubit,
    required this.currentBrief,
    required this.controller,
    required this.cardStackWidth,
    required this.cardStackHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabBarCubit = useCubit<TabBarCubit>();
    final lastPageAnimationProgressState = useMemoized(() => ValueNotifier(0.0));

    useEffect(() {
      final listener = () {
        lastPageAnimationProgressState.value =
            calculateLastPageShownFactor(controller, AppDimens.topicCardWidthViewportFraction);
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    useCubitListener<TabBarCubit, TabBarState>(tabBarCubit, (cubit, state, context) {
      state.maybeWhen(
        tabPressed: (tab) {
          if (tab == MainTab.today) {
            controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCubic);
          }
        },
        orElse: () {},
      );
    });

    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (context.isNotSmallDevice) ...[
                const SizedBox(height: AppDimens.s),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: _Greeting(
                    greeting: currentBrief.greeting,
                    lastPageAnimationProgressState: lastPageAnimationProgressState,
                  ),
                ),
                const SizedBox(height: AppDimens.m),
              ],
            ],
          );
        }
        return Container(
            width: MediaQuery.of(context).size.width,
            height: cardStackHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StackedCardsRandomVariantBuilder(
                  count: currentBrief.topics.length,
                  builder: (variants) => PageViewStackedCards.variant(
                    variant: variants[index],
                    coverSize: Size(cardStackWidth, cardStackHeight),
                    child: ReadingListCover(
                      topic: currentBrief.topics[index],
                      onTap: () => _onTopicCardPressed(context, index, currentBrief),
                    ),
                  ),
                )
              ],
            ));
      },
      childCount: currentBrief.topics.length,
    )
        // CustomScrollView(
        //   scrollBehavior: NoGlowScrollBehavior(),
        //   physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        //   slivers: [
        //     SliverToBoxAdapter(
        //       child: SizedBox(
        //         height: constraints.maxHeight,
        //         child: StackedCardsRandomVariantBuilder(
        //             count: currentBrief.topics.length,
        //             builder: (variants) {
        //               return NoScrollGlow(
        //                 child: PageView(
        //                   allowImplicitScrolling: true,
        //                   controller: controller,
        //                   scrollDirection: Axis.horizontal,
        //                   onPageChanged: (index) {
        //                     if (index < currentBrief.topics.length) {
        //                       todaysTopicsCubit.trackTopicPageSwipe(
        //                         currentBrief.topics[index].id,
        //                         index + 1,
        //                       );
        //                     } else {
        //                       todaysTopicsCubit.trackRelaxPage();
        //                     }
        //                   },
        //                   children: [
        //                     ..._buildTopicCards(
        //                       context,
        //                       controller,
        //                       todaysTopicsCubit,
        //                       currentBrief,
        //                       cardStackWidth,
        //                       constraints.maxHeight,
        //                       variants,
        //                     ),
        //                     Hero(
        //                       tag: HeroTag.dailyBriefRelaxPage,
        //                       child: RelaxView(
        //                         lastPageAnimationProgressState: lastPageAnimationProgressState,
        //                         goodbyeHeadline: currentBrief.goodbye,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               );
        //             }),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }

  void _onTopicCardPressed(BuildContext context, int index, CurrentBrief currentBrief) {
    AutoRouter.of(context).push(
      TopicPage(
        topicSlug: currentBrief.topics[index].id,
        topic: currentBrief.topics[index],
        briefId: currentBrief.id,
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final Headline greeting;
  final ValueNotifier<double> lastPageAnimationProgressState;

  const _Greeting({
    required this.greeting,
    required this.lastPageAnimationProgressState,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: lastPageAnimationProgressState,
      builder: (BuildContext context, double value, Widget? child) {
        return AnimatedOpacity(
          opacity: value < 0.5 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
      child: InformedMarkdownBody(
        markdown: greeting.headline,
        baseTextStyle: AppTypography.b1Regular,
        textAlignment: TextAlign.left,
      ),
    );
  }
}
