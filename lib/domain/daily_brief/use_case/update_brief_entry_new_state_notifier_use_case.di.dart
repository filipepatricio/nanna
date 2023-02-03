import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_entry_new_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateBriefEntryNewStateNotifierUseCase {
  const UpdateBriefEntryNewStateNotifierUseCase(this._notifier);

  final BriefEntryNewStateNotifier _notifier;

  void call(BriefEntry entry) => _notifier.notify(entry);
}
