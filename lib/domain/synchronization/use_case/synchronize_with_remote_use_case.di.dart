import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';

abstract class SynchronizeWithRemoteUsecase<T> {
  Future<Synchronizable<T>> call(Synchronizable<T> synchronizable, bool hasActiveSubscription);
}
