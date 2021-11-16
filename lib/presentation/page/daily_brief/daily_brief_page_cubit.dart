import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class DailyBriefPageCubit extends Cubit<DailyBriefPageState> {
  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  late CurrentBrief _currentBrief;

  DailyBriefPageCubit(
    this._getCurrentBriefUseCase,
    this._trackActivityUseCase,
  ) : super(DailyBriefPageState.loading());

  Future<void> initialize() async {
    emit(DailyBriefPageState.loading());

    try {
      _currentBrief = await _getCurrentBriefUseCase();
      emit(DailyBriefPageState.idle(_currentBrief));
    } catch (e, s) {
      Fimber.e('Loading current brief failed', ex: e, stacktrace: s);
      emit(DailyBriefPageState.error());
    }
  }

  Future<void> logTopicPageView(String topicId) => _trackActivityUseCase.logTopicPage(topicId);
}
