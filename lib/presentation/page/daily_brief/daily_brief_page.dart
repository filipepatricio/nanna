import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_section.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_subsection.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_scrollable_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/widgets/daily_brief_calendar.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/images.dart';
import 'package:better_informed_mobile/presentation/util/markdown_util.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/brief_entry_cover/brief_entry_cover.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const _topicCardTutorialOffsetFromBottomFraction = 1.4;

class DailyBriefPage extends HookWidget {
  const DailyBriefPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DailyBriefPageCubit>();
    final state = useCubitBuilder(cubit);
    final tutorialCoachMark = cubit.tutorialCoachMark(context);

    final body = _DailyBriefPage(
      state: state,
      cubit: cubit,
      tutorialCoachMark: tutorialCoachMark,
    );

    return Platform.isAndroid
        ? WillPopScope(
            onWillPop: () => cubit.onAndroidBackButtonPress(tutorialCoachMark.isShowing),
            child: body,
          )
        : body;
  }
}

class _DailyBriefPage extends HookWidget {
  const _DailyBriefPage({
    required this.state,
    required this.cubit,
    required this.tutorialCoachMark,
    Key? key,
  }) : super(key: key);

  final DailyBriefPageState state;
  final DailyBriefPageCubit cubit;
  final TutorialCoachMark tutorialCoachMark;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cardStackWidth = MediaQuery.of(context).size.width;
    const cardStackHeight = AppDimens.briefEntryCardStackHeight;

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
            onRefresh: cubit.loadBriefs,
            color: AppColors.darkGrey,
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
                    showCalendar: state.showCalendar,
                    scrollController: scrollController,
                    briefDate: state.currentBrief.date,
                    pastDaysBriefs: state.pastDaysBriefs,
                    showAppBarTitle: state.showAppBarTitle,
                    cubit: cubit,
                  ),
                  orElse: () => const SliverToBoxAdapter(),
                ),
                state.maybeMap(
                  idle: (state) => SliverPinnedHeader(
                    child: DailyBriefCalendar(
                      isVisible: state.showCalendar,
                      currentBriefDate: state.currentBrief.date,
                      pastDaysBriefs: state.pastDaysBriefs,
                      isFloating: state.showAppBarTitle,
                      cubit: cubit,
                      scrollController: scrollController,
                    ),
                  ),
                  orElse: () => const SliverToBoxAdapter(),
                ),
                state.maybeMap(
                  idle: (state) => _IdleContent(
                    cubit: cubit,
                    brief: state.currentBrief,
                    cardStackWidth: cardStackWidth,
                    cardStackHeight: cardStackHeight,
                    tutorialCoachMark: tutorialCoachMark,
                    scrollController: scrollController,
                  ),
                  error: (_) => SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimens.l,
                      AppDimens.safeTopPadding(context),
                      AppDimens.l,
                      AppDimens.zero,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: CardsErrorView(
                          retryAction: cubit.loadBriefs,
                          size: Size(cardStackWidth, cardStackHeight),
                        ),
                      ),
                    ),
                  ),
                  loading: (_) => SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimens.l,
                      AppDimens.safeTopPadding(context),
                      AppDimens.l,
                      AppDimens.zero,
                    ),
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
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimens.l),
                ),
                const SliverToBoxAdapter(
                  child: AudioPlayerBannerPlaceholder(),
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
  const _IdleContent({
    required this.cubit,
    required this.brief,
    required this.cardStackWidth,
    required this.cardStackHeight,
    required this.tutorialCoachMark,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final DailyBriefPageCubit cubit;
  final Brief brief;
  final double cardStackWidth;
  final double cardStackHeight;
  final TutorialCoachMark tutorialCoachMark;
  final ScrollController scrollController;

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

  bool didListScrollReachTopicCard(ScrollController listScrollController, double topicCardTriggerPoint) {
    return listScrollController.offset >= topicCardTriggerPoint && !listScrollController.position.outOfRange;
  }

  @override
  Widget build(BuildContext context) {
    final isShowingTutorialToast = useState(false);
    final cloudinaryProvider = useCloudinaryProvider();

    useEffect(
      () {
        cubit.initializeTutorialSnackBar();
      },
      [cubit],
    );

    useCubitListener<DailyBriefPageCubit, DailyBriefPageState>(cubit, (cubit, state, _) {
      state.whenOrNull(
        preCacheImages: (briefEntryList) {
          final mediaQuery = MediaQuery.maybeOf(context);

          if (mediaQuery != null) {
            precacheBriefFullScreenImages(
              context,
              cloudinaryProvider,
              briefEntryList,
            );
          }
        },
        shouldShowTopicCardTutorialCoachMark: () {
          final topicCardTriggerPoint =
              scrollController.offset + AppDimens.appBarHeight * _topicCardTutorialOffsetFromBottomFraction;
          final listener = topicCardTutorialListener(scrollController, topicCardTriggerPoint);
          scrollController.addListener(listener);
        },
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
        showTopicCardTutorialCoachMark: () => tutorialCoachMark.show(context: context),
        skipTutorialCoachMark: (_) => tutorialCoachMark.skip(),
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

    BriefEntry? firstTopic;
    if (brief.allEntries.any((entry) => entry.isTopic)) {
      firstTopic = brief.allEntries.firstWhere(
        (element) => element.item.maybeMap(
          topicPreview: (_) => true,
          orElse: () => false,
        ),
      );
    }

    return MultiSliver(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: _Greeting(
            greeting: brief.greeting,
            introduction: brief.introduction,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => brief.sections[index].map(
              entries: (section) => _BriefSection(
                title: section.title,
                backgroundColor: section.backgroundColor,
                children: section.entries.expand(
                  (entry) => [
                    BriefEntryCover(
                      briefEntry: entry,
                      briefId: brief.id,
                      width: cardStackWidth,
                      height: cardStackHeight,
                      padding: _needsDivider(section, entry)
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(
                              bottom: AppDimens.l,
                            ),
                      topicCardKey: entry == firstTopic ? firstTopicKey : null,
                      onVisibilityChanged: (visibility) {
                        if (entry == firstTopic && visibility.visibleFraction == 1) {
                          cubit.initializeTutorialCoachMark();
                        }
                        if (!kIsTest) {
                          cubit.trackBriefEntryPreviewed(
                            entry,
                            index,
                            visibility.visibleFraction,
                          );
                        }
                      },
                    ),
                    if (_needsDivider(section, entry))
                      const InformedDivider(
                        padding: EdgeInsets.symmetric(vertical: AppDimens.sl),
                      ),
                  ],
                ),
              ),
              subsections: (section) => _BriefSection(
                title: section.title,
                backgroundColor: section.backgroundColor,
                children: section.subsections.map(
                  (subsection) => _BriefSubsection(
                    subsection: subsection,
                    children: subsection.entries.map(
                      (entry) => BriefEntryCover(
                        briefEntry: entry,
                        briefId: brief.id,
                        width: cardStackWidth,
                        height: cardStackHeight,
                        topicCardKey: entry == firstTopic ? firstTopicKey : null,
                        onVisibilityChanged: (visibility) {
                          if (entry == firstTopic) {
                            cubit.initializeTutorialCoachMark();
                          }
                          if (!kIsTest) {
                            cubit.trackBriefEntryPreviewed(
                              entry,
                              index,
                              visibility.visibleFraction,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              unknown: (_) => const SizedBox.shrink(),
            ),
            childCount: brief.sections.length,
            addAutomaticKeepAlives: false,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.l,
            AppDimens.m,
            AppDimens.l,
            AppDimens.zero,
          ),
          sliver: SliverToBoxAdapter(
            child: _RelaxSection(
              onVisible: cubit.trackRelaxPage,
              relax: brief.relax,
            ),
          ),
        ),
      ],
    );
  }

  bool _needsDivider(BriefSectionWithEntries section, BriefEntry entry) =>
      section.backgroundColor == null &&
      entry.style.type == BriefEntryStyleType.articleCardSmallItem &&
      entry != section.entries.last &&
      section.entries[section.entries.indexOf(entry) + 1].style.type == BriefEntryStyleType.articleCardSmallItem;
}

class _BriefSubsection extends StatelessWidget {
  const _BriefSubsection({
    required this.subsection,
    required this.children,
    Key? key,
  }) : super(key: key);

  final BriefSubsection subsection;
  final Iterable<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          subsection.title,
          textAlign: TextAlign.start,
          style: AppTypography.h4ExtraBold,
        ),
        ...children,
        const SizedBox(height: AppDimens.sl),
      ],
    );
  }
}

class _BriefSection extends StatelessWidget {
  const _BriefSection({
    required this.title,
    required this.children,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color? backgroundColor;
  final Iterable<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: title,
            baseTextStyle: AppTypography.h1MediumLora,
          ),
          const SizedBox(height: AppDimens.m),
          ...children,
          const SizedBox(height: AppDimens.m),
        ],
      ),
    );
  }
}

class _RelaxSection extends StatelessWidget {
  const _RelaxSection({
    required this.onVisible,
    required this.relax,
    Key? key,
  }) : super(key: key);

  static const String relaxSectionKey = 'kRelaxSectionKey';
  final VoidCallback onVisible;
  final Relax relax;

  @override
  Widget build(BuildContext context) {
    return ViewVisibilityNotifier(
      detectorKey: const Key(relaxSectionKey),
      onVisible: onVisible,
      borderFraction: 0.6,
      child: RelaxView.dailyBrief(
        relax: relax,
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
  final BriefIntroduction? introduction;

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
