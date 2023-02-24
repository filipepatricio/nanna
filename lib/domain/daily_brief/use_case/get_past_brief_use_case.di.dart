import 'package:better_informed_mobile/domain/daily_brief/daily_brief_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/save_brief_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPastBriefUseCase {
  GetPastBriefUseCase(
    this._dailyBriefRepository,
    this._dailyBriefLocalRepository,
    this._saveBriefLocallyUseCase,
  );

  final DailyBriefRepository _dailyBriefRepository;
  final DailyBriefLocalRepository _dailyBriefLocalRepository;
  final SaveBriefLocallyUseCase _saveBriefLocallyUseCase;

  Future<Brief> call(DateTime date) async {
    try {
      final brief = await _dailyBriefRepository.getPastBrief(date);
      _saveBriefLocallyUseCase(brief).ignore();
      return brief;
    } on NoInternetConnectionException {
      final synchronizable = await _dailyBriefLocalRepository.load(date.toIso8601String());
      final brief = synchronizable?.data;
      if (brief == null) rethrow;
      return brief;
    }
  }
}
