import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class GeneralEventTrackerCubit extends Cubit {
  final TrackActivityUseCase _trackActivityUseCase;

  GeneralEventTrackerCubit(this._trackActivityUseCase) : super(null);

  void trackEvent(AnalyticsEvent event) {
    _trackActivityUseCase.trackEvent(event);
  }
}
