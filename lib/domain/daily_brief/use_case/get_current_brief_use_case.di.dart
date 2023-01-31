import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_wrapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/update_brief_unseen_count_state_notifier_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentBriefUseCase {
  const GetCurrentBriefUseCase(
    this._dailyBriefRepository,
    this._updateBriefUnseenCountStateNotifierUseCase,
  );

  final DailyBriefRepository _dailyBriefRepository;
  final UpdateBriefUnseenCountStateNotifierUseCase _updateBriefUnseenCountStateNotifierUseCase;

  Future<BriefsWrapper> call() async {
    final briefsWrapper = await _dailyBriefRepository.getCurrentBrief();
    _updateBriefUnseenCountStateNotifierUseCase.call(briefsWrapper.currentBrief.unseenCount);
    return briefsWrapper;
  }

  Stream<BriefsWrapper> get stream => _dailyBriefRepository.currentBriefStream();
}
