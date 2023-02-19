import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';

abstract class SynchronizableEntityMapper<A, B>
    implements BidirectionalMapper<SynchronizableEntity<A>, Synchronizable<B>> {
  SynchronizableEntityMapper(this.dataMapper);

  final BidirectionalMapper<A, B> dataMapper;

  @override
  SynchronizableEntity<A> from(Synchronizable<B> data) {
    final item = data.data;
    final synchronizedAt = data.map(
      synchronized: (data) => data.synchronizedAt,
      notSynchronized: (_) => null,
    );

    return createEntity(
      data: item != null ? dataMapper.from(item) : null,
      dataId: data.dataId,
      createdAt: data.createdAt.toIso8601String(),
      synchronizedAt: synchronizedAt?.toIso8601String(),
      expirationDate: data.expirationDate.toIso8601String(),
    );
  }

  @override
  Synchronizable<B> to(SynchronizableEntity<A> data) {
    final item = data.data;
    final synchronizedAt = data.synchronizedAt;

    if (item != null && synchronizedAt != null) {
      return Synchronizable.synchronized(
        data: dataMapper.to(item),
        dataId: data.dataId,
        createdAt: DateTime.parse(data.createdAt),
        synchronizedAt: DateTime.parse(synchronizedAt),
        expirationDate: DateTime.parse(data.expirationDate),
      );
    } else {
      return Synchronizable.notSynchronized(
        data: item != null ? dataMapper.to(item) : null,
        dataId: data.dataId,
        createdAt: DateTime.parse(data.createdAt),
        expirationDate: DateTime.parse(data.expirationDate),
      );
    }
  }

  SynchronizableEntity<A> createEntity({
    required A? data,
    required String dataId,
    required String createdAt,
    required String? synchronizedAt,
    required String expirationDate,
  });
}
