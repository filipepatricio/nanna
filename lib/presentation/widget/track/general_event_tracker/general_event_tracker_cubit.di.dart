import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class GeneralEventTrackerCubit extends Cubit {
  GeneralEventTrackerCubit(this._trackActivityUseCase) : super(null);
  final TrackActivityUseCase _trackActivityUseCase;

  void trackEvent(AnalyticsEvent event) {
    _trackActivityUseCase.trackEvent(event);
  }
}
