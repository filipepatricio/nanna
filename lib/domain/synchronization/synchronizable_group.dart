import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_with_remote_use_case.di.dart';

class SynchronizableGroup<T> {
  SynchronizableGroup(
    this.repository,
    this.synchronizeWithRemoteUseCase,
  );

  final SynchronizableRepository<T> repository;
  final SynchronizeWithRemoteUsecase<T>? synchronizeWithRemoteUseCase;

  Future<void> runSync(Future<void> Function<T>(SynchronizableGroup<T>) sync) async {
    return sync<T>(this);
  }
}
