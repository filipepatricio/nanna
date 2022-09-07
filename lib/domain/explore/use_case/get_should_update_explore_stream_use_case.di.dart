import 'package:better_informed_mobile/domain/general/should_refresh_visit_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShouldUpdateExploreStreamUseCase {
  GetShouldUpdateExploreStreamUseCase(this._notifier);

  final ShouldRefreshVisitStateNotifier _notifier;

  Stream<bool> call() {
    return _notifier.stream;
  }
}
