import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/track/topic_summary_tracker/topic_summary_tracker_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicSummaryTracker extends HookWidget {
  final Topic topic;
  final PageController summaryPageController;
  final Widget child;

  const TopicSummaryTracker({
    required this.topic,
    required this.summaryPageController,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicSummaryTrackerCubit>();
    final state = useCubitBuilder<TopicSummaryTrackerCubit, TopicSummaryTrackerState>(
      cubit,
      buildWhen: (_) => true,
    );

    useEffect(
      () {
        if (state == TopicSummaryTrackerState.disabled) return () {};

        final listener = () {
          cubit.track(topic, summaryPageController.page);
        };
        summaryPageController.addListener(listener);
        return () => summaryPageController.removeListener(listener);
      },
      [summaryPageController, state],
    );

    return child;
  }
}
