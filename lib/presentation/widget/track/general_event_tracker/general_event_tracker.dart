import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef EventCallback = void Function(AnalyticsEvent event);

GeneralEventTrackerController useEventTrackController() {
  return useMemoized(() => GeneralEventTrackerController());
}

class GeneralEventTrackerController {
  EventCallback? _onEvent;

  GeneralEventTrackerController();

  void track(AnalyticsEvent event) {
    _onEvent?.call(event);
  }
}

class GeneralEventTracker extends HookWidget {
  final GeneralEventTrackerController controller;
  final Widget child;

  const GeneralEventTracker({
    required this.controller,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GeneralEventTrackerCubit>();

    useEffect(
      () {
        final listener = (AnalyticsEvent event) => cubit.trackEvent(event);
        controller._onEvent = listener;
        return () => controller._onEvent = null;
      },
      [cubit, controller],
    );

    return child;
  }
}
