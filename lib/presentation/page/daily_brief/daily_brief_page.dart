import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
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
import 'package:better_informed_mobile/presentation/widget/card_divider.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curation_info_view.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/owners_note.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
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
    final cloudinaryProvider = useCloudinaryProvider();

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<DailyBriefPageCubit, DailyBriefPageState>(cubit, (cubit, state, _) {
      state.whenOrNull(
        showPaywall: () => context.pushRoute(const SubscriptionPageRoute()),
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
            color: AppColors.of(context).iconPrimary,
            child: SnackbarParentView(
              audioPlayerResponsive: true,
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
                      briefDate: state.selectedBrief.date,
                      pastDays: state.pastDays,
                      showAppBarTitle: state.showAppBarTitle,
                      cubit: cubit,
                    ),
                    loadingPastDay: (state) => DailyBriefScrollableAppBar(
                      showCalendar: true,
                      scrollController: scrollController,
                      briefDate: state.selectedPastDay.date,
                      pastDays: state.pastDays,
                      showAppBarTitle: state.showAppBarTitle,
                      cubit: cubit,
                    ),
                    orElse: () => const SliverToBoxAdapter(),
                  ),
                  state.maybeMap(
                    idle: (state) => SliverPinnedHeader(
                      child: DailyBriefCalendar(
                        isVisible: state.showCalendar,
                        selectedBriefDate: state.selectedBrief.date,
                        pastDays: state.pastDays,
                        isFloating: state.showAppBarTitle,
                        cubit: cubit,
                        scrollController: scrollController,
                      ),
                    ),
                    loadingPastDay: (state) => SliverPinnedHeader(
                      child: DailyBriefCalendar(
                        isVisible: true,
                        selectedBriefDate: state.selectedPastDay.date,
                        pastDays: state.pastDays,
                        isFloating: state.showAppBarTitle,
                        cubit: cubit,
                        scrollController: scrollController,
                        isInLoadingState: true,
                      ),
                    ),
                    orElse: SliverAppBar.new,
                  ),
                  state.maybeMap(
                    idle: (state) => _IdleContent(
                      cubit: cubit,
                      brief: state.selectedBrief,
                      tutorialCoachMark: tutorialCoachMark,
                      scrollController: scrollController,
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
                    loadingPastDay: (_) => SliverToBoxAdapter(
                      child: DailyBriefLoadingView(
                        coverSize: Size(
                          AppDimens.topicCardBigMaxWidth(context),
                          AppDimens.topicCardBigMaxHeight,
                        ),
                      ),
                    ),
                    orElse: () => const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    ),
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
    Key? key,
  }) : super(key: key);

  final DailyBriefPageCubit cubit;
  final Brief brief;
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

    useEffect(
      () {
        cubit.initializeTutorialSnackBar();
      },
      [cubit],
    );

    useCubitListener<DailyBriefPageCubit, DailyBriefPageState>(cubit, (cubit, state, _) {
      state.whenOrNull(
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
        finishTutorialCoachMark: () {
          try {
            if (tutorialCoachMark.isShowing) {
              tutorialCoachMark.finish();
            }
          } catch (_) {}
        },
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
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin) +
              const EdgeInsets.only(top: AppDimens.m, bottom: AppDimens.xl),
          sliver: SliverToBoxAdapter(
            child: _Greeting(
              greeting: brief.greeting,
              introduction: brief.introduction,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => brief.sections[index].map(
              entries: (section) => _BriefSection(
                title: section.title,
                backgroundColor: section.backgroundColor,
                children: _mapEntriesToCovers(section, firstTopic, index),
              ),
              subsections: (section) => _BriefSection(
                title: section.title,
                backgroundColor: section.backgroundColor,
                children: _mapSubsectionsToWidgets(section, firstTopic, index),
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
  ) sync* {
    final startingIndex = _calculateStartingIndexForSection(index);

    for (int i = 0; i < section.entries.length; i++) {
      final entry = section.entries[i];
      yield BriefEntryCover(
        briefEntry: entry,
        briefId: brief.id,
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

      if (i < section.entries.length - 1) {
        yield const CardDivider.cover();
      }
    }
  }

  Iterable<Widget> _mapSubsectionsToWidgets(
    BriefSectionWithSubsections section,
    BriefEntry? firstTopic,
    int sectionIndex,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CardDivider.section(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
            child: InformedMarkdownBody(
              markdown: title,
              baseTextStyle: AppTypography.sansTitleLargeLausanne,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [...children],
          ),
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
    final dummyEditorialTeamCurationInfo = CurationInfo(
      LocaleKeys.dailyBrief_dummyEditorialTeamCurationInfo_byLine.tr(),
      Curator.editorialTeam(
        name: LocaleKeys.dailyBrief_dummyEditorialTeamCurationInfo_name.tr(),
        bio: LocaleKeys.dailyBrief_dummyEditorialTeamCurationInfo_bio.tr(),
      ),
    );
    return OwnersNoteContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InformedMarkdownBody(
            markdown: greeting.headline,
            baseTextStyle: AppTypography.b2Medium.copyWith(
              color: AppColors.of(context).textSecondary,
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
          const SizedBox(height: AppDimens.xs),
          CurationInfoView(
            curationInfo: dummyEditorialTeamCurationInfo,
            imageDimension: AppDimens.smallAvatarSize,
            style: AppTypography.sansTextNanoLausanne.copyWith(
              color: AppColors.of(context).textTertiary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
