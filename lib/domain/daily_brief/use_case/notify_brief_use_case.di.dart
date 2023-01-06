import 'package:better_informed_mobile/domain/general/should_refresh_page_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateBriefNotifierUseCase {
  const UpdateBriefNotifierUseCase(this._notifier);

  final ShouldRefreshPageNotifier _notifier;

  void call() => _notifier.notify();
}
