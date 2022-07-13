import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPastDaysBriesfUseCase {
  GetPastDaysBriesfUseCase(this._dailyBriefRepository);
  final DailyBriefRepository _dailyBriefRepository;

  Future<List<PastDaysBrief>> call() => _dailyBriefRepository.getPastDaysBriefs();
}
