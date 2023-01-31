import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';

abstract class SynchronizableRepository<T> {
  Future<void> save(Synchronizable<T> synchronizable);

  Future<Synchronizable<T>?> load(String id);

  Future<void> delete(String id);

  Future<List<String>> getAllIds();
}
