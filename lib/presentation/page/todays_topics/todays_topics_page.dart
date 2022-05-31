import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_scrollable_app_bar.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/markdown_util.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
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
    final cardStackWidth = MediaQuery.of(context).size.width;
    const cardStackHeight = AppDimens.todaysTopicCardStackHeight;

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
                  state.maybeMap(
                    idle: (state) => TodaysTopicsScrollableAppBar(
                      scrollController: scrollController,
                      briefDate: state.currentBrief.date,
                    ),
                    orElse: () => const SliverToBoxAdapter(),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.l,
                      AppDimens.zero,
                      AppDimens.l,
                      AppDimens.xxxc + AppDimens.xxl,
                    ),
                    sliver: state.maybeMap(
                      idle: (state) => _IdleContent(
                        todaysTopicsCubit: cubit,
                        currentBrief: state.currentBrief,
                        scrollController: scrollController,
                        cardStackWidth: cardStackWidth,
                        cardStackHeight: cardStackHeight,
                      ),
                      error: (_) => SliverToBoxAdapter(
                        child: Center(
                          child: CardsErrorView(
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
          introduction: currentBrief.introduction,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final currentTopic = currentBrief.topics[index];
              return ViewVisibilityNotifier(
                detectorKey: Key(currentTopic.id),
                onVisible: () => todaysTopicsCubit.trackTopicPreviewed(currentTopic.id, index),
                borderFraction: 0.6,
                child: Column(
                  children: [
                    SizedBox(
                      height: cardStackHeight,
                      width: cardStackWidth,
                      child: TopicCover.large(
                        topic: currentTopic.asPreview,
                        onTap: () => _onTopicCardPressed(
                          context,
                          index,
                          currentBrief,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.l),
                  ],
                ),
              );
            },
            childCount: currentBrief.topics.length,
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
    required this.introduction,
    Key? key,
  }) : super(key: key);

  final Headline greeting;
  final CurrentBriefIntroduction? introduction;

  @override
  Widget build(BuildContext context) {
    final intro = introduction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        InformedMarkdownBody(
          markdown: greeting.headline,
          baseTextStyle: AppTypography.b3Medium.copyWith(color: AppColors.textGrey),
        ),
        if (intro != null) ...[
          const SizedBox(height: AppDimens.s),
          Container(
            padding: const EdgeInsets.all(AppDimens.l),
            decoration: const BoxDecoration(
              color: AppColors.pastelGreen,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  AppDimens.l,
                ),
              ),
            ),
            child: InformedMarkdownBody(
              markdown: '${MarkdownUtil.getRawSvgMarkdownImage(intro.icon)} ${intro.text}',
              baseTextStyle: AppTypography.b2Medium,
              textAlignment: TextAlign.left,
              markdownImageBuilder: MarkdownUtil.rawSvgMarkdownBuilder,
            ),
          ),
        ],
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}
