import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_unseen_count_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBriefUnseenCountStateStreamUseCase {
  GetBriefUnseenCountStateStreamUseCase(this._notifier);

  final BriefUnseenCountStateNotifier _notifier;

  Stream<int> call() {
    return _notifier.stream;
  }
}
