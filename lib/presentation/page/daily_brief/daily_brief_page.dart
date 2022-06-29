import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_scrollable_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/markdown_util.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/brief_entry_cover/brief_entry_cover.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _topicCardTutorialOffsetFromBottomFraction = 1.4;

class DailyBriefPage extends HookWidget {
  const DailyBriefPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DailyBriefPageCubit>();
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();
    final cardStackWidth = MediaQuery.of(context).size.width;
    const cardStackHeight = AppDimens.briefEntryCardStackHeight;
    final topPadding = AppDimens.safeTopPadding(context);
    final tutorialCoachMark = cubit.tutorialCoachMark(context);

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
            onRefresh: cubit.loadDailyBrief,
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
                    idle: (state) => DailyBriefScrollableAppBar(
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
                      AppDimens.l,
                    ),
                    sliver: state.maybeMap(
                      idle: (state) => _IdleContent(
                        cubit: cubit,
                        currentBrief: state.currentBrief,
                        cardStackWidth: cardStackWidth,
                        cardStackHeight: cardStackHeight,
                        tutorialCoachMark: tutorialCoachMark,
                        scrollController: scrollController,
                      ),
                      error: (_) => SliverPadding(
                        padding: EdgeInsets.only(top: topPadding),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: CardsErrorView(
                              retryAction: cubit.loadDailyBrief,
                              size: Size(cardStackWidth, cardStackHeight),
                            ),
                          ),
                        ),
                      ),
                      loading: (_) => SliverPadding(
                        padding: EdgeInsets.only(top: topPadding),
                        sliver: SliverToBoxAdapter(
                          child: DailyBriefLoadingView(
                            coverSize: Size(
                              cardStackWidth,
                              cardStackHeight,
                            ),
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
    required this.cubit,
    required this.currentBrief,
    required this.cardStackWidth,
    required this.cardStackHeight,
    required this.tutorialCoachMark,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final DailyBriefPageCubit cubit;
  final CurrentBrief currentBrief;
  final double cardStackWidth;
  final double cardStackHeight;
  final TutorialCoachMark tutorialCoachMark;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final isShowingTutorialToast = useState(false);

    useCubitListener<DailyBriefPageCubit, DailyBriefPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) {
          isShowingTutorialToast.value = true;
          showInfoToast(
            context: context,
            text: text,
            onDismiss: () {
              isShowingTutorialToast.value = false;
            },
          );
        },
        showTopicCardTutorialCoachMark: tutorialCoachMark.show,
        skipTutorialCoachMark: (jumpToNextCoachMark) {
          tutorialCoachMark.skip();
        },
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

    useCubitListener<DailyBriefPageCubit, DailyBriefPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        shouldShowTopicCardTutorialCoachMark: () {
          final topicCardTriggerPoint = scrollController.offset +
              AppDimens.briefEntryCardStackHeight *
                  (context.isSmallDevice ? 1.0 : _topicCardTutorialOffsetFromBottomFraction);
          final listener = topicCardTutorialListener(scrollController, topicCardTriggerPoint);
          scrollController.addListener(listener);
        },
      );
    });

    return MultiSliver(
      children: [
        _Greeting(
          greeting: currentBrief.greeting,
          introduction: currentBrief.introduction,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final currentEntry = currentBrief.entries[index];
              final firstTopic = currentBrief.entries
                  .firstWhere((element) => element.item.maybeMap(topicPreview: (_) => true, orElse: () => false));

              return VisibilityDetector(
                key: Key(currentEntry.id),
                onVisibilityChanged: kIsTest
                    ? null
                    : (visibility) {
                        if (currentEntry == firstTopic) {
                          cubit.initializeTutorialCoachMark();
                        }
                        cubit.trackBriefEntryPreviewed(
                          currentEntry,
                          index,
                          visibility.visibleFraction,
                        );
                      },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BriefEntryCover(
                      briefEntry: currentEntry,
                      briefId: currentBrief.id,
                      width: cardStackWidth,
                      height: cardStackHeight,
                      topicCardKey: currentEntry == firstTopic ? cubit.topicCardKey : null,
                    ),
                    const SizedBox(height: AppDimens.l),
                  ],
                ),
              );
            },
            childCount: currentBrief.entries.length,
            addAutomaticKeepAlives: false,
          ),
        ),
        _RelaxSection(
          onVisible: cubit.trackRelaxPage,
          goodbyeHeadline: currentBrief.goodbye,
        ),
      ],
    );
  }

  bool didListScrollReachTopicCard(ScrollController listScrollController, double topicCardTriggerPoint) {
    return listScrollController.offset >= topicCardTriggerPoint && !listScrollController.position.outOfRange;
  }

  VoidCallback topicCardTutorialListener(ScrollController listScrollController, double topicCardTriggerPoint) {
    var isToShowMediaItemTutorialCoachMark = true;
    void topicCardListener() {
      if (isToShowMediaItemTutorialCoachMark &&
          didListScrollReachTopicCard(listScrollController, topicCardTriggerPoint)) {
        listScrollController.jumpTo(
          topicCardTriggerPoint,
        );
        cubit.showTopicCardTutorialCoachMark();
        isToShowMediaItemTutorialCoachMark = false;
        scrollController.removeListener(topicCardListener);
      }
    }

    return topicCardListener;
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
        const SizedBox(height: AppDimens.xs),
        InformedMarkdownBody(
          markdown: greeting.headline,
          baseTextStyle: AppTypography.b3Medium.copyWith(color: AppColors.textGrey),
        ),
        if (intro != null) ...[
          const SizedBox(height: AppDimens.m),
          Container(
            padding: const EdgeInsets.all(AppDimens.l),
            decoration: const BoxDecoration(
              color: AppColors.pastelGreen,
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimens.m),
              ),
            ),
            child: InformedMarkdownBody(
              markdown: '${MarkdownUtil.getRawSvgMarkdownImage(intro.icon)}   ${intro.text}',
              baseTextStyle: AppTypography.b2Medium,
              textAlignment: TextAlign.left,
              markdownImageBuilder: (uri, title, alt) => MarkdownUtil.rawSvgMarkdownBuilder(
                uri,
                title,
                alt,
                AppTypography.b2Medium.fontSize! * 1.2,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppDimens.m),
      ],
    );
  }
}
