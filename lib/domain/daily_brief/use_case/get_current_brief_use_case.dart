import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentBriefUseCase {
  final DailyBriefRepository _dailyBriefRepository;

  GetCurrentBriefUseCase(this._dailyBriefRepository);

  Future<CurrentBrief> call() => _dailyBriefRepository.getCurrentBrief();
}
