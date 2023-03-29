import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/exception/synchronizable_invalidated_exception.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_group.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SynchronizeAllUseCase {
  SynchronizeAllUseCase(
    this._groups,
    this._saveSynchronizableItemUseCase,
    this._hasActiveSubscriptionUseCase,
  );

  final List<SynchronizableGroup> _groups;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;

  Future<void> call() async {
    final hasActiveSubscription = await _hasActiveSubscriptionUseCase();

    Fimber.i('Start syncing all repositories');
    for (final group in _groups) {
      await group.runSync(_synchronizeRepository, hasActiveSubscription);
    }
    Fimber.i('Syncing all repositories finished');
  }

  Future<void> _synchronizeRepository<T>(SynchronizableGroup<T> group, bool hasActiveSubscription) async {
    final repository = group.repository;
    final idList = await repository.getAllIds();
    for (final id in idList) {
      final synchronizable = await repository.load(id);
      if (synchronizable != null) {
        try {
          await _synchronizeItem<T>(synchronizable, group, id, hasActiveSubscription);
        } catch (e, s) {
          Fimber.e('Item failed to synchronize: $id', ex: e, stacktrace: s);
        }
      }
    }
  }

  Future<void> _synchronizeItem<T>(
    Synchronizable<T> synchronizable,
    SynchronizableGroup<T> group,
    String id,
    bool hasActiveSubscription,
  ) async {
    if (synchronizable.isExpired) {
      await group.repository.delete(id);
    } else if (synchronizable is NotSynchronized<T>) {
      await _synchronizeWithRemote<T>(synchronizable, group, hasActiveSubscription);
    }
  }

  Future<void> _synchronizeWithRemote<T>(
    Synchronizable<T> synchronizable,
    SynchronizableGroup<T> group,
    bool hasActiveSubscription,
  ) async {
    final useCase = group.synchronizeWithRemoteUseCase;
    if (useCase == null) return;

    try {
      final synchronized = await useCase(synchronizable, hasActiveSubscription);
      await _saveSynchronizableItemUseCase(group.repository, synchronized);
    } on SynchronizableInvalidatedException {
      await group.repository.delete(synchronizable.dataId);
    }
  }
}
