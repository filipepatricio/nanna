import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPastBriefUseCase {
  GetPastBriefUseCase(this._dailyBriefRepository);

  final DailyBriefRepository _dailyBriefRepository;

  Future<Brief> call(DateTime date) => _dailyBriefRepository.getPastBrief(date);
}
