import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_group.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizeAllUseCase {
  SynchronizeAllUseCase(
    this._groups,
    this._saveSynchronizableItemUseCase,
  );

  final List<SynchronizableGroup> _groups;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;

  Future<void> call() async {
    for (final group in _groups) {
      await _synchronizeRepository(group);
    }
  }

  Future<void> _synchronizeRepository<T>(SynchronizableGroup<T> group) async {
    final repository = group.repository;
    final idList = await repository.getAllIds();
    for (final id in idList) {
      final synchronizable = await repository.load(id);
      if (synchronizable != null) {
        try {
          await _synchronizeItem<T>(synchronizable, group, id);
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
  ) async {
    if (synchronizable.isExpired) {
      await group.repository.delete(id);
    } else if (synchronizable is NotSynchronized<T>) {
      await _synchronizeWithRemote<T>(synchronizable, group);
    }
  }

  Future<void> _synchronizeWithRemote<T>(
    Synchronizable<T> synchronizable,
    SynchronizableGroup<T> group,
  ) async {
    final useCase = group.synchronizeWithRemoteUseCase;
    if (useCase == null) return;

    final synchronized = await useCase(synchronizable);
    await _saveSynchronizableItemUseCase(group.repository, synchronized);
  }
}
