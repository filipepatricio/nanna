import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_unseen_count_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DecreaseBriefUnseenCountStateNotifierUseCase {
  DecreaseBriefUnseenCountStateNotifierUseCase(this._notifier);

  final BriefUnseenCountStateNotifier _notifier;
  final Set<String> _slugs = {};

  void call(String slug) {
    if (_slugs.add(slug)) {
      _notifier.decrease();
    }
  }
}
