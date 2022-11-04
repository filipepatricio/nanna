import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_introduction.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_section.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_subsection.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';
import 'package:better_informed_mobile/exports.dart';
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
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final tutorialCoachMark = cubit.tutorialCoachMark();

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
    final snackbarController = useMemoized(() => SnackbarController());

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<DailyBriefPageCubit, DailyBriefPageState>(cubit, (cubit, state, _) {
      state.whenOrNull(
        showPaywall: () => context.pushRoute(const SubscriptionPageRoute()),
      );
    });

    return Scaffold(
      body: TabBarListener(
        currentPage: context.routeData,
        scrollController: scrollController,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: RefreshIndicator(
            onRefresh: cubit.loadBriefs,
            color: AppColors.darkGrey,
            child: SnackbarParentView(
              controller: snackbarController,
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
                    orElse: () => const SliverAppBar(systemOverlayStyle: SystemUiOverlayStyle.dark),
                  ),
                  state.maybeMap(
                    idle: (state) => _IdleContent(
                      cubit: cubit,
                      brief: state.currentBrief,
                      tutorialCoachMark: tutorialCoachMark,
                      scrollController: scrollController,
                      snackbarController: snackbarController,
                    ),
                    error: (_) => SliverFillRemaining(
                      child: Center(
                        child: GeneralErrorView(
                          title: LocaleKeys.common_error_title.tr(),
                          content: LocaleKeys.common_error_body.tr(),
                          retryCallback: cubit.loadBriefs,
                        ),
                      ),
                    ),
                    loading: (_) => SliverToBoxAdapter(
                      child: DailyBriefLoadingView(
                        coverSize: Size(
                          AppDimens.topicCardBigMaxWidth(context),
                          AppDimens.topicCardBigMaxHeight,
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
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  const _IdleContent({
    required this.cubit,
    required this.brief,
    required this.tutorialCoachMark,
    required this.scrollController,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final DailyBriefPageCubit cubit;
  final Brief brief;
  final TutorialCoachMark tutorialCoachMark;
  final ScrollController scrollController;
  final SnackbarController snackbarController;

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
        showTopicCardTutorialCoachMark: () => tutorialCoachMark.show(context: context, rootOverlay: true),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pageHorizontalMargin,
            vertical: AppDimens.ml,
          ),
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
                children: _mapEntriesToCovers(section, firstTopic, index, snackbarController),
              ),
              subsections: (section) => _BriefSection(
                title: section.title,
                backgroundColor: section.backgroundColor,
                children: _mapSubsectionsToWidgets(section, firstTopic, index, snackbarController),
              ),
              unknown: (_) => const SizedBox.shrink(),
            ),
            childCount: brief.sections.length,
            addAutomaticKeepAlives: false,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pageHorizontalMargin,
              AppDimens.m,
              AppDimens.pageHorizontalMargin,
              AppDimens.zero,
            ),
            child: _RelaxSection(
              onVisible: cubit.trackRelaxPage,
              relax: brief.relax,
            ),
          ),
        ),
      ],
    );
  }

  Iterable<Widget> _mapEntriesToCovers(
    BriefSectionWithEntries section,
    BriefEntry? firstTopic,
    int index,
    SnackbarController snackbarController,
  ) sync* {
    final startingIndex = _calculateStartingIndexForSection(index);

    for (int i = 0; i < section.entries.length; i++) {
      final entry = section.entries[i];

      yield const InformedDivider(
        padding: EdgeInsets.symmetric(vertical: AppDimens.m),
      );

      yield BriefEntryCover(
        briefEntry: entry,
        briefId: brief.id,
        snackbarController: snackbarController,
        topicCardKey: entry == firstTopic ? firstTopicKey : null,
        onVisibilityChanged: (visibility) {
          if (entry == firstTopic && visibility.visibleFraction == 1) {
            cubit.initializeTutorialCoachMark();
          }
          if (!kIsTest) {
            cubit.trackBriefEntryPreviewed(
              entry,
              startingIndex + i,
              visibility.visibleFraction,
            );
          }
        },
      );
    }
  }

  Iterable<Widget> _mapSubsectionsToWidgets(
    BriefSectionWithSubsections section,
    BriefEntry? firstTopic,
    int sectionIndex,
    SnackbarController snackbarController,
  ) sync* {
    for (int i = 0; i < section.subsections.length; i++) {
      final subsection = section.subsections[i];

      yield _BriefSubsection(
        subsection: subsection,
        children: _mapSubsectionEntries(
          section,
          subsection,
          firstTopic,
          sectionIndex,
          i,
          snackbarController,
        ),
      );
    }
  }

  Iterable<Widget> _mapSubsectionEntries(
    BriefSectionWithSubsections section,
    BriefSubsection subsection,
    BriefEntry? firstTopic,
    int sectionIndex,
    int subsectionIndex,
    SnackbarController snackbarController,
  ) sync* {
    final startingIndexWithoutSubsections = _calculateStartingIndexForSection(sectionIndex, subsectionIndex);
    final startingIndex = startingIndexWithoutSubsections +
        (subsectionIndex == 0
            ? 0
            : section.subsections
                .take(subsectionIndex)
                .map((e) => e.entries.length)
                .reduce((value, element) => value + element));

    for (int i = 0; i < subsection.entries.length; i++) {
      final entry = subsection.entries[i];

      yield BriefEntryCover(
        briefEntry: entry,
        briefId: brief.id,
        snackbarController: snackbarController,
        topicCardKey: entry == firstTopic ? firstTopicKey : null,
        onVisibilityChanged: (visibility) {
          if (entry == firstTopic) {
            cubit.initializeTutorialCoachMark();
          }
          if (!kIsTest) {
            cubit.trackBriefEntryPreviewed(
              entry,
              startingIndex + i,
              visibility.visibleFraction,
            );
          }
        },
      );
    }
  }

  int _calculateStartingIndexForSection(int sectionIndex, [int? subsectionIndex]) {
    if (sectionIndex == 0) return 0;

    return brief.sections
        .take(sectionIndex)
        .map(
          (element) => element.map(
            entries: (element) => element.entries.length,
            subsections: (element) => element.subsections
                .map((subsection) => subsection.entries.length)
                .reduce((value, element) => element + value),
            unknown: (_) => 0,
          ),
        )
        .reduce((value, element) => value + element);
  }
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
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: title,
            baseTextStyle: AppTypography.h0Medium,
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

    return Container(
      padding: const EdgeInsets.only(left: AppDimens.sl),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.limeGreen)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InformedMarkdownBody(
            markdown: greeting.headline,
            baseTextStyle: AppTypography.b2Medium.copyWith(
              color: AppColors.textGrey,
              height: 1,
            ),
          ),
          if (intro != null) ...[
            const SizedBox(height: AppDimens.xs),
            InformedMarkdownBody(
              markdown: intro.text,
              baseTextStyle: AppTypography.b2Medium,
              textAlignment: TextAlign.left,
              markdownImageBuilder: (uri, title, alt) => MarkdownUtil.rawSvgMarkdownBuilder(
                uri,
                title,
                alt,
                AppTypography.b2Medium.fontSize! * 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
