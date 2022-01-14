import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page_state.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_title_hero.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_data.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/util/scroll_behaviour/no_glow_scroll_behaviour.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final cardStackWidth = MediaQuery.of(context).size.width * AppDimens.topicCardWidthViewportFraction;

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
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: false,
          titleSpacing: AppDimens.l,
          title: Row(
            children: [
              TodaysTopicsTitleHero(
                title: relaxState.value ? LocaleKeys.todaysTopics_relax.tr() : LocaleKeys.todaysTopics_title.tr(),
              ),
              const Spacer(),
              Visibility(
                visible: relaxState.value,
                child: Container(
                  height: AppDimens.s,
                  width: AppDimens.s,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.xxs),
                    color: AppColors.limeGreen,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.s),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state.maybeMap(
                idle: (state) => _IdleContent(
                  todaysTopicsCubit: cubit,
                  currentBrief: state.currentBrief,
                  controller: controller,
                  cardStackWidth: cardStackWidth,
                ),
                error: (_) => RefreshIndicator(
                  onRefresh: cubit.initialize,
                  color: AppColors.darkGrey,
                  child: CustomScrollView(
                    scrollBehavior: NoGlowScrollBehavior(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: StackedCardsErrorView(retryAction: cubit.initialize, cardStackWidth: cardStackWidth),
                        ),
                      ),
                    ],
                  ),
                ),
                loading: (_) => StackedCardsLoadingView(cardStackWidth: cardStackWidth),
                orElse: () => const SizedBox(),
              ),
            );
          },
        ));
  }
}

class _IdleContent extends HookWidget {
  final TodaysTopicsPageCubit todaysTopicsCubit;
  final CurrentBrief currentBrief;
  final PageController controller;
  final double cardStackWidth;

  const _IdleContent({
    required this.todaysTopicsCubit,
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
        lastPageAnimationProgressState.value =
            calculateLastPageShownFactor(controller, AppDimens.topicCardWidthViewportFraction);
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return ReadingBannerWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (kIsNotSmallDevice) ...[
            const SizedBox(height: AppDimens.l),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: _Greeting(
                greeting: currentBrief.greeting,
                lastPageAnimationProgressState: lastPageAnimationProgressState,
              ),
            ),
          ],
          const SizedBox(height: AppDimens.sl),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return RefreshIndicator(
                        onRefresh: todaysTopicsCubit.initialize,
                        color: AppColors.darkGrey,
                        child: CustomScrollView(
                          scrollBehavior: NoGlowScrollBehavior(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: constraints.maxHeight,
                                child: NoScrollGlow(
                                  child: PageView(
                                    allowImplicitScrolling: true,
                                    controller: controller,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index) {
                                      if (index < currentBrief.topics.length) {
                                        todaysTopicsCubit.trackTopicPageSwipe(currentBrief.topics[index].id, index + 1);
                                      } else {
                                        todaysTopicsCubit.trackRelaxPage();
                                      }
                                    },
                                    children: [
                                      ..._buildTopicCards(
                                        context,
                                        controller,
                                        todaysTopicsCubit,
                                        currentBrief,
                                        cardStackWidth,
                                        constraints.maxHeight,
                                      ),
                                      Hero(
                                        tag: HeroTag.dailyBriefRelaxPage,
                                        child: RelaxView(
                                          lastPageAnimationProgressState: lastPageAnimationProgressState,
                                          goodbyeHeadline: currentBrief.goodbye,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kIsSmallDevice ? AppDimens.m : AppDimens.l),
          Center(
            child: _DotIndicator(currentBrief: currentBrief, controller: controller),
          ),
          SizedBox(height: kIsSmallDevice ? AppDimens.m : AppDimens.l),
        ],
      ),
    );
  }

  Iterable<Widget> _buildTopicCards(
    BuildContext context,
    PageController controller,
    TodaysTopicsPageCubit dailyBriefCubit,
    CurrentBrief currentBrief,
    double width,
    double heightPageView,
  ) {
    return currentBrief.topics.asMap().map<int, Widget>((key, value) {
      return MapEntry(
        key,
        Padding(
          padding: EdgeInsets.only(left: kIsSmallDevice ? AppDimens.m : AppDimens.l),
          child: PageViewStackedCards.random(
            coverSize: Size(width, heightPageView),
            child: ReadingListCover(
              topic: currentBrief.topics[key],
              onTap: () => _onTopicCardPressed(context, key, currentBrief),
            ),
          ),
        ),
      );
    }).values;
  }

  void _onTopicCardPressed(BuildContext context, int index, CurrentBrief currentBrief) {
    AutoRouter.of(context).push(
      TodaysTopicsTopicPage(pageData: TopicPageData.item(topic: currentBrief.topics[index], briefId: currentBrief.id)),
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

class _DotIndicator extends StatelessWidget {
  final CurrentBrief currentBrief;
  final PageController controller;

  const _DotIndicator({
    required this.currentBrief,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageDotIndicator(
      pageCount: currentBrief.topics.length + 1,
      controller: controller,
    );
  }
}
