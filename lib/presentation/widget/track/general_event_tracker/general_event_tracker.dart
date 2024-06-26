import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef EventCallback = void Function(AnalyticsEvent event);

GeneralEventTrackingController useEventTrackingController() {
  return useMemoized(() => GeneralEventTrackingController());
}

class GeneralEventTrackingController {
  GeneralEventTrackingController();
  EventCallback? _onEvent;

  void track(AnalyticsEvent event) {
    _onEvent?.call(event);
  }
}

class GeneralEventTracker extends HookWidget {
  const GeneralEventTracker({
    required this.controller,
    required this.child,
    Key? key,
  }) : super(key: key);
  final GeneralEventTrackingController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GeneralEventTrackerCubit>();

    useEffect(
      () {
        void listener(AnalyticsEvent event) => cubit.trackEvent(event);
        controller._onEvent = listener;
        return () => controller._onEvent = null;
      },
      [cubit, controller],
    );

    return child;
  }
}
