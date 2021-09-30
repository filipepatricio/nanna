import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_title_hero.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/stacked_cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/stacked_cards_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _pageViewportFraction = 0.9;

class DailyBriefPage extends HookWidget {
  const DailyBriefPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DailyBriefPageCubit>();
    final state = useCubitBuilder(cubit);
    final controller = usePageController(viewportFraction: _pageViewportFraction);
    final relaxState = useState(false);
    final cardStackWidth = MediaQuery.of(context).size.width * 0.9;

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

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: DailyBriefTitleHero(
          title: relaxState.value ? LocaleKeys.dailyBrief_relax.tr() : LocaleKeys.dailyBrief_title.tr(),
        ),
        centerTitle: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: state.maybeMap(
          idle: (state) => _IdleContent(
            currentBrief: state.currentBrief,
            controller: controller,
            cardStackWidth: cardStackWidth,
          ),
          error: (_) => StackedCardsErrorView(cardStackWidth: cardStackWidth),
          loading: (_) => StackedCardsLoadingView(cardStackWidth: cardStackWidth),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  final CurrentBrief currentBrief;
  final PageController controller;
  final double cardStackWidth;

  const _IdleContent({
    required this.currentBrief,
    required this.controller,
    required this.cardStackWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastPageAnimationProgressState = useMemoized(() => ValueNotifier(0.0));

    useEffect(() {
      final listener = () {
        lastPageAnimationProgressState.value = calculateLastPageShownFactor(controller, _pageViewportFraction);
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return ReadingBannerWrapper(
      child: Stack(
        children: [
          Hero(
            tag: HeroTag.dailyBriefRelaxPage,
            flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
              return Material(
                color: Colors.transparent,
                child: RelaxView(
                  lastPageAnimationProgressState: lastPageAnimationProgressState,
                  goodbyeHeadline: currentBrief.goodbye,
                ),
              );
            },
            child: RelaxView(
              lastPageAnimationProgressState: lastPageAnimationProgressState,
              goodbyeHeadline: currentBrief.goodbye,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.m),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return PageView(
                      padEnds: false,
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      children: [
                        ..._buildTopicCards(
                          context,
                          controller,
                          currentBrief,
                          cardStackWidth,
                          constraints.maxHeight,
                        ),
                        Container(),
                      ],
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: lastPageAnimationProgressState,
                builder: (BuildContext context, double value, Widget? child) {
                  return AnimatedOpacity(
                    opacity: value < 0.5 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppDimens.l,
                    top: AppDimens.l,
                    bottom: AppDimens.l,
                  ),
                  child: PageDotIndicator(
                    pageCount: currentBrief.topics.length,
                    controller: controller,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Iterable<Widget> _buildTopicCards(
    BuildContext context,
    PageController controller,
    CurrentBrief currentBrief,
    double width,
    double heightPageView,
  ) {
    return currentBrief.topics.asMap().map<int, Widget>((key, value) {
      return MapEntry(
        key,
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.xl),
          child: ReadingListStackedCards(
            coverSize: Size(width, heightPageView),
            child: ReadingListCover(
              topic: currentBrief.topics[key],
              onTap: () => _onTopicCardPressed(context, controller, key, currentBrief),
            ),
          ),
        ),
      );
    }).values;
  }

  void _onTopicCardPressed(BuildContext context, PageController controller, int index, CurrentBrief currentBrief) {
    AutoRouter.of(context).push(
      TopicPageRoute(
        index: index,
        onPageChanged: (index) {
          controller.jumpToPage(index);
        },
        currentBrief: currentBrief,
      ),
    );
  }
}
