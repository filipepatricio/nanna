import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_title_hero.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_topic_card.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DailyBriefPage extends HookWidget {
  const DailyBriefPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(viewportFraction: 0.9);
    final lastPageAnimationProgressState = useState(0.0);

    useEffect(() {
      final listener = () {
        lastPageAnimationProgressState.value = calculateLastPageShownFactor(controller, 0.9);
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const DailyBriefTitleHero(),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Hero(
            tag: 'relax-page',
            flightShuttleBuilder: (context, anim, direction, contextA, contextB) {
              return Material(
                color: Colors.transparent,
                child: RelaxView(lastPageAnimationProgressState: lastPageAnimationProgressState),
              );
            },
            child: RelaxView(lastPageAnimationProgressState: lastPageAnimationProgressState),
          ),
          PageView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            children: [
              DailyBriefTopicCard(
                index: 0,
                onPressed: () => _onTopicCardPressed(context, controller, 0),
              ),
              DailyBriefTopicCard(
                index: 1,
                onPressed: () => _onTopicCardPressed(context, controller, 1),
              ),
              DailyBriefTopicCard(
                index: 2,
                onPressed: () => _onTopicCardPressed(context, controller, 2),
              ),
              Container(),
            ],
          ),
        ],
      ),
    );
  }

  void _onTopicCardPressed(BuildContext context, PageController controller, int index) {
    AutoRouter.of(context).push(
      TopicPageRoute(
        index: index,
        onPageChanged: (index) {
          controller.jumpToPage(index);
        },
      ),
    );
  }
}
