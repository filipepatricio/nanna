import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveSynchronizableItemUseCase {
  Future<void> call<T>(
    SynchronizableRepository<T> repository,
    Synchronizable<T> item,
  ) async {
    final existingItem = await repository.load(item.dataId);
    if (existingItem == null) {
      await repository.save(item);
    } else {
      final newItem = _mergeData(item, existingItem);
      await repository.save(newItem);
    }
  }

  Synchronizable<T> _mergeData<T>(Synchronizable<T> item, Synchronizable<T> existingItem) {
    final longerExpirationDate =
        item.expirationDate.isAfter(existingItem.expirationDate) ? item.expirationDate : existingItem.expirationDate;
    final data = item.maybeData ?? existingItem.maybeData;
    final synchronizedAt = item.maybeSynchronizedAt ?? existingItem.maybeSynchronizedAt;

    if (data != null && synchronizedAt != null) {
      return Synchronizable.synchronized(
        data: data,
        dataId: existingItem.dataId,
        createdAt: existingItem.createdAt,
        synchronizedAt: synchronizedAt,
        expirationDate: longerExpirationDate,
      );
    } else {
      return Synchronizable.notSynchronized(
        dataId: existingItem.dataId,
        createdAt: existingItem.createdAt,
        expirationDate: longerExpirationDate,
      );
    }
  }
}
