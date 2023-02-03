import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_unseen_count_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class DecreaseBriefUnseenCountStateNotifierUseCase {
  const DecreaseBriefUnseenCountStateNotifierUseCase(this._notifier);

  final BriefUnseenCountStateNotifier _notifier;

  void call() => _notifier.decrease();
}
