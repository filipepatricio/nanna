import 'package:better_informed_mobile/domain/daily_brief/daily_brief_calendar_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_calendar.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_day.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_days.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_wrapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/save_brief_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/update_brief_unseen_count_state_notifier_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentBriefUseCase {
  const GetCurrentBriefUseCase(
    this._dailyBriefRepository,
    this._dailyBriefLocalRepository,
    this._dailyBriefCalendarLocalRepository,
    this._saveBriefLocallyUseCase,
    this._updateBriefUnseenCountStateNotifierUseCase,
  );

  final DailyBriefRepository _dailyBriefRepository;
  final DailyBriefLocalRepository _dailyBriefLocalRepository;
  final DailyBriefCalendarLocalRepository _dailyBriefCalendarLocalRepository;
  final SaveBriefLocallyUseCase _saveBriefLocallyUseCase;
  final UpdateBriefUnseenCountStateNotifierUseCase _updateBriefUnseenCountStateNotifierUseCase;

  Future<BriefsWrapper> call() async {
    try {
      final briefsWrapper = await _dailyBriefRepository.getCurrentBrief();
      _updateBriefUnseenCountStateNotifierUseCase.call(briefsWrapper.currentBrief.unseenCount);
      await _saveLocally(briefsWrapper);
      return briefsWrapper;
    } on NoInternetConnectionException {
      final briefsWrapper = await _getLocally();
      if (briefsWrapper != null) return briefsWrapper;

      rethrow;
    }
  }

  Future<BriefsWrapper> guest() async {
    try {
      final briefsWrapper = await _dailyBriefRepository.getCurrentBriefGuest();
      _updateBriefUnseenCountStateNotifierUseCase.call(briefsWrapper.currentBrief.unseenCount);
      return briefsWrapper;
    } on NoInternetConnectionException {
      final briefsWrapper = await _getLocally();
      if (briefsWrapper != null) return briefsWrapper;

      rethrow;
    }
  }

  Stream<BriefsWrapper> get stream => _dailyBriefRepository.currentBriefStream().asyncMap((event) async {
        _updateBriefUnseenCountStateNotifierUseCase.call(event.currentBrief.unseenCount);
        await _saveLocally(event);
        return event;
      });

  Future<void> _saveLocally(BriefsWrapper briefsWrapper) async {
    try {
      await _saveBriefLocallyUseCase(briefsWrapper.currentBrief);

      final calendar = BriefCalendar(
        current: briefsWrapper.currentBrief.date,
        pastItems: briefsWrapper.pastDays.days.map((e) => e.date).toList(),
      );
      await _dailyBriefCalendarLocalRepository.save(calendar);
    } catch (e, s) {
      Fimber.e('Error while saving brief locally', ex: e, stacktrace: s);
    }
  }

  Future<BriefsWrapper?> _getLocally() async {
    final calendar = await _dailyBriefCalendarLocalRepository.load();

    if (calendar != null) {
      final briefSynchrinizable = await _dailyBriefLocalRepository.load(calendar.current.toIso8601String());
      final brief = briefSynchrinizable?.data;

      if (brief != null) {
        final storedBriefs = await _dailyBriefLocalRepository.getAllIds();

        return BriefsWrapper(
          brief,
          BriefPastDays(
            calendar.pastItems
                .map((item) => BriefPastDay(item, storedBriefs.contains(item.toIso8601String())))
                .toList(),
          ),
        );
      }
    }
  }
}
