import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

enum TopicSummaryTrackerState { enabled, disabled }

@injectable
class TopicSummaryTrackerCubit extends Cubit<TopicSummaryTrackerState> {
  final TrackActivityUseCase _trackActivityUseCase;

  TopicSummaryTrackerCubit(this._trackActivityUseCase) : super(TopicSummaryTrackerState.enabled);

  void track(Topic topic, double? position) {
    if (position == topic.topicSummaryList.length - 1) {
      emit(TopicSummaryTrackerState.disabled);

      _trackActivityUseCase.trackEvent(AnalyticsEvent.topicSummaryRead(topic.id));
    }
  }
}
