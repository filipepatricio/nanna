import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_title_hero.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_topic_card.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/error.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _pageViewportFraction = 0.9;

class DailyBriefPage extends HookWidget {
  const DailyBriefPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DailyBriefPageCubit>();
    final state = useCubitBuilder(cubit);
    final controller = usePageController(viewportFraction: _pageViewportFraction);
    final relaxState = useState(false);

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
        title: DailyBriefTitleHero(
          title: relaxState.value ? LocaleKeys.dailyBrief_relax.tr() : LocaleKeys.dailyBrief_title.tr(),
        ),
        centerTitle: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: state.maybeMap(
          idle: (state) => _IdleContent(currentBrief: state.currentBrief, controller: controller),
          error: (_) => const AppError(graphicPath: AppVectorGraphics.briefError),
          loading: (_) => const _Loading(),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }
}

class _IdleContent extends HookWidget {
  final CurrentBrief currentBrief;
  final PageController controller;

  const _IdleContent({
    required this.currentBrief,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastPageAnimationProgressState = useState(0.0);

    useEffect(() {
      final listener = () {
        lastPageAnimationProgressState.value = calculateLastPageShownFactor(controller, _pageViewportFraction);
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return Stack(
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
        PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: [
            ..._buildTopicCards(context, controller, currentBrief),
            Container(),
          ],
        ),
      ],
    );
  }

  Iterable<Widget> _buildTopicCards(BuildContext context, PageController controller, CurrentBrief currentBrief) {
    return currentBrief.topics.asMap().map<int, Widget>((key, value) {
      return MapEntry(
        key,
        DailyBriefTopicCard(
          index: key,
          onPressed: () => _onTopicCardPressed(context, controller, key, currentBrief),
          topic: value,
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

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppVectorGraphics.briefLoading),
        const SizedBox(height: AppDimens.l),
        Text(
          LocaleKeys.dailyBrief_loading.tr(),
          style: AppTypography.b3Regular.copyWith(height: 1.61),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
