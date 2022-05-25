import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/scrollable_sliver_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
        scrollController: scrollController,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: RefreshIndicator(
            onRefresh: cubit.loadTodaysTopics,
            color: AppColors.darkGrey,
            child: NoScrollGlow(
              child: CustomScrollView(
                controller: scrollController,
                physics: state.maybeMap(
                  error: (_) => const NeverScrollableScrollPhysics(),
                  loading: (_) => const NeverScrollableScrollPhysics(),
                  orElse: () => AlwaysScrollableScrollPhysics(parent: getPlatformScrollPhysics()),
                ),
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
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const SliverToBoxAdapter(
                    child: AudioPlayerBannerPlaceholder(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  const _IdleContent({
    required this.todaysTopicsCubit,
    required this.currentBrief,
    required this.scrollController,
    required this.cardStackWidth,
    required this.cardStackHeight,
    Key? key,
  }) : super(key: key);

  final TodaysTopicsPageCubit todaysTopicsCubit;
  final CurrentBrief currentBrief;
  final ScrollController scrollController;
  final double cardStackWidth;
  final double cardStackHeight;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        _Greeting(
          greeting: currentBrief.greeting,
        ),
        StackedCardsRandomVariantBuilder<StackedCardsVariant>(
          variants: StackedCardsVariant.values,
          count: currentBrief.topics.length,
          canNeighboursRepeat: false,
          builder: (variants) => SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final currentTopic = currentBrief.topics[index];
                return ViewVisibilityNotifier(
                  detectorKey: Key(currentTopic.id),
                  onVisible: () => todaysTopicsCubit.trackTopicPreviewed(currentTopic.id, index),
                  borderFraction: 0.6,
                  child: Column(
                    children: [
                      StackedCards.variant(
                        variant: variants[index],
                        coverSize: Size(cardStackWidth, cardStackHeight),
                        child: TopicCover.large(
                          topic: currentTopic.asPreview,
                          onTap: () => _onTopicCardPressed(
                            context,
                            index,
                            currentBrief,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.xxxl),
                    ],
                  ),
                );
              },
              childCount: currentBrief.topics.length,
            ),
          ),
        ),
        _RelaxSection(
          onVisible: todaysTopicsCubit.trackRelaxPage,
          goodbyeHeadline: currentBrief.goodbye,
        ),
      ],
    );
  }

  void _onTopicCardPressed(BuildContext context, int index, CurrentBrief currentBrief) {
    AutoRouter.of(context).push(
      TopicPage(
        topicSlug: currentBrief.topics[index].slug,
        briefId: currentBrief.id,
        topic: currentBrief.topics[index],
      ),
    );
  }
}

class _RelaxSection extends StatelessWidget {
  const _RelaxSection({
    required this.onVisible,
    required this.goodbyeHeadline,
    Key? key,
  }) : super(key: key);

  static const String relaxSectionKey = 'kRelaxSectionKey';
  final VoidCallback onVisible;
  final Headline goodbyeHeadline;

  @override
  Widget build(BuildContext context) {
    return ViewVisibilityNotifier(
      detectorKey: const Key(relaxSectionKey),
      onVisible: onVisible,
      borderFraction: 0.6,
      child: RelaxView(
        goodbyeHeadline: goodbyeHeadline,
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.greeting,
    Key? key,
  }) : super(key: key);

  final Headline greeting;

  @override
  Widget build(BuildContext context) {
    if (context.isSmallDevice) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.l,
        AppDimens.zero,
        AppDimens.l,
        AppDimens.xl,
      ),
      child: InformedMarkdownBody(
        markdown: greeting.headline,
        baseTextStyle: AppTypography.b2Regular,
        textAlignment: TextAlign.left,
      ),
    );
  }
}
