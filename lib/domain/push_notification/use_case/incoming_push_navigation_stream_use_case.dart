import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class IncomingPushNavigationStreamUseCase {
  final PushNotificationRepository _repository;

  IncomingPushNavigationStreamUseCase(this._repository);

  Stream<IncomingPushActionNavigateTo> call() {
    return _repository
        .pushNotificationOpenStream()
        .map((event) => Stream.fromIterable(event.actions))
        .flatMap((value) => value)
        .whereType<IncomingPushActionNavigateTo>();
  }
}
