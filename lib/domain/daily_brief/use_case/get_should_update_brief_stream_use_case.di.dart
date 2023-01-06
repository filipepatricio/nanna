import 'package:better_informed_mobile/domain/general/should_refresh_page_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShouldUpdateBriefStreamUseCase {
  GetShouldUpdateBriefStreamUseCase(this._notifier);

  final ShouldRefreshPageNotifier _notifier;

  Stream<bool> call() {
    return _notifier.stream;
  }
}
