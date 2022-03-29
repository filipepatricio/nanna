import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stack_card_variant.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/round_topic_cover_large.dart';
import 'package:better_informed_mobile/presentation/widget/scrollable_sliver_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'todays_topics_page_state.dart';

class TodaysTopicsPage extends HookWidget {
  const TodaysTopicsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TodaysTopicsPageCubit>();
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();
    final cardStackWidth = MediaQuery.of(context).size.width * AppDimens.topicCardWidthViewportFraction;
    final cardStackHeight = AppDimens.todaysTopicCardStackHeight(context);

    useCubitListener<TodaysTopicsPageCubit, TodaysTopicsPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) => Future.delayed(const Duration(milliseconds: 100), () {
          showInfoToast(
            context: context,
            text: text,
          );
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
      body: TabBarListener(
        currentPage: context.routeData,
        controller: scrollController,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: cubit.loadTodaysTopics,
                color: AppColors.darkGrey,
                child: NoScrollGlow(
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(parent: getPlatformScrollPhysics()),
                    slivers: [
                      ScrollableSliverAppBar(
                        scrollController: scrollController,
                        title: LocaleKeys.todaysTopics_title.tr(),
                      ),
                      state.maybeMap(
                        idle: (state) => _IdleContent(
                          todaysTopicsCubit: cubit,
                          currentBrief: state.currentBrief,
                          scrollController: scrollController,
                          cardStackWidth: cardStackWidth,
                          cardStackHeight: cardStackHeight,
                        ),
                        error: (_) => SliverToBoxAdapter(
                          child: Center(
                            child: StackedCardsErrorView(
                              retryAction: cubit.loadTodaysTopics,
                              size: Size(cardStackWidth, cardStackHeight),
                            ),
                          ),
                        ),
                        loading: (_) => SliverToBoxAdapter(
                          child: TodaysTopicsLoadingView(
                            coverSize: Size(
                              cardStackWidth,
                              cardStackHeight,
                            ),
                          ),
                        ),
                        orElse: () => const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  final TodaysTopicsPageCubit todaysTopicsCubit;
  final CurrentBrief currentBrief;
  final ScrollController scrollController;
  final double cardStackWidth;
  final double cardStackHeight;

  const _IdleContent({
    required this.todaysTopicsCubit,
    required this.currentBrief,
    required this.scrollController,
    required this.cardStackWidth,
    required this.cardStackHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastPageAnimationProgressState = useMemoized(() => ValueNotifier(0.0));

    useEffect(
      () {
        final listener = () {
          lastPageAnimationProgressState.value = calculateLastPageShownFactor(
            scrollController,
            AppDimens.todaysTopicCardStackHeight(context),
          );
        };
        scrollController.addListener(listener);
        return () => scrollController.removeListener(listener);
      },
      [scrollController],
    );

    return StackedCardsRandomVariantBuilder<RoundStackCardVariant>(
      variants: RoundStackCardVariant.values,
      count: currentBrief.topics.length,
      canNeighboursRepeat: false,
      builder: (variants) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == 0) {
              return _Greeting(
                greeting: currentBrief.greeting,
              );
            } else if (index == currentBrief.topics.length + 1) {
              return _RelaxSection(
                onVisible: todaysTopicsCubit.trackRelaxPage,
                goodbyeHeadline: currentBrief.goodbye,
                lastPageAnimationProgressState: lastPageAnimationProgressState,
              );
            } else {
              final currentTopicIndex = index - 1;
              final currentTopic = currentBrief.topics[currentTopicIndex];
              return ViewVisibilityNotifier(
                detectorKey: Key(currentTopic.id),
                onVisible: () => todaysTopicsCubit.trackTopicPreviewed(currentTopic.id, currentTopicIndex + 1),
                borderFraction: 0.6,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _onTopicCardPressed(
                        context,
                        currentTopicIndex,
                        currentBrief,
                      ),
                      child: RoundStackedCards.variant(
                        variant: variants[currentTopicIndex],
                        coverSize: Size(cardStackWidth, cardStackHeight),
                        child: RoundTopicCoverLarge(
                          topic: currentTopic,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.xxxl),
                  ],
                ),
              );
            }
          },
          childCount: currentBrief.topics.length + 2,
        ),
      ),
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

class _RelaxSection extends StatelessWidget {
  const _RelaxSection({
    required this.onVisible,
    required this.lastPageAnimationProgressState,
    required this.goodbyeHeadline,
    Key? key,
  }) : super(key: key);

  static const String relaxSectionKey = 'kRelaxSectionKey';
  final VoidCallback onVisible;
  final Headline goodbyeHeadline;
  final ValueNotifier<double> lastPageAnimationProgressState;

  @override
  Widget build(BuildContext context) {
    return ViewVisibilityNotifier(
      detectorKey: const Key(relaxSectionKey),
      onVisible: onVisible,
      borderFraction: 0.6,
      child: RelaxView(
        lastPageAnimationProgressState: lastPageAnimationProgressState,
        goodbyeHeadline: goodbyeHeadline,
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final Headline greeting;

  const _Greeting({
    required this.greeting,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (context.isNotSmallDevice) ...[
          const SizedBox(height: AppDimens.s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: InformedMarkdownBody(
              markdown: greeting.headline,
              baseTextStyle: AppTypography.b2Regular,
              textAlignment: TextAlign.left,
            ),
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ],
    );
  }
}
