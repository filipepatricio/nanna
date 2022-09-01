import 'package:better_informed_mobile/domain/daily_brief/should_update_brief_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShouldUpdateBriefStreamUseCase {
  GetShouldUpdateBriefStreamUseCase(this._notifier);

  final ShouldUpdateBriefNotifier _notifier;

  Stream<bool> call() {
    return _notifier.stream;
  }
}
