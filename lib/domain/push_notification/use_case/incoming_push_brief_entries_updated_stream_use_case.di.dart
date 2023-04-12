import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncomingPushBriefEntriesUpdatedStreamUseCase {
  IncomingPushBriefEntriesUpdatedStreamUseCase(this._repository);
  final PushNotificationRepository _repository;

  Stream<void> call() {
    return _repository
        .pushNotificationMessageStream()
        .where((event) => event.actions.whereType<IncomingPushActionBriefEntriesUpdated>().isNotEmpty);
  }
}
