import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_entry_new_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBriefEntryNewStateStreamUseCase {
  GetBriefEntryNewStateStreamUseCase(this._notifier);

  final BriefEntryNewStateNotifier _notifier;

  Stream<BriefEntrySeen> call(String slug) {
    return _notifier.stream.where((event) => event.slug == slug);
  }
}
