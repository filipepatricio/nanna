import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dart';

abstract class SynchronizableEntityMapper<A, B>
    implements BidirectionalMapper<SynchronizableEntity<A>, Synchronizable<B>> {
  SynchronizableEntityMapper(this.dataMapper);

  final BidirectionalMapper<A, B> dataMapper;

  @override
  SynchronizableEntity<A> from(Synchronizable<B> data) {
    return createEntity(
      data: dataMapper.from(data.data),
      createdAt: data.createdAt.toIso8601String(),
      synchronizedAt: data.synchronizedAt.toIso8601String(),
      expirationDate: data.expirationDate.toIso8601String(),
    );
  }

  @override
  Synchronizable<B> to(SynchronizableEntity<A> data) {
    return Synchronizable(
      data: dataMapper.to(data.data),
      createdAt: DateTime.parse(data.createdAt),
      synchronizedAt: DateTime.parse(data.synchronizedAt),
      expirationDate: DateTime.parse(data.expirationDate),
    );
  }

  SynchronizableEntity<A> createEntity({
    required A data,
    required String createdAt,
    required String synchronizedAt,
    required String expirationDate,
  });
}
