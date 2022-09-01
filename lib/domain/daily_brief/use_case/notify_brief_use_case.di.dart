import 'package:better_informed_mobile/domain/daily_brief/should_update_brief_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateBriefNotifierUseCase {
  const UpdateBriefNotifierUseCase(this._notifier);

  final ShouldUpdateBriefNotifier _notifier;

  void call() => _notifier.notify();
}
