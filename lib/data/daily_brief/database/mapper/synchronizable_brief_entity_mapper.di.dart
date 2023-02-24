import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/synchronizable_brief_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/mapper/brief_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/synchronization/database/entity/synchronizable_entity.hv.dart';
import 'package:better_informed_mobile/data/synchronization/database/mapper/synchronziable_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizableBriefEntityMapper extends SynchronizableEntityMapper<BriefEntity, Brief> {
  SynchronizableBriefEntityMapper(BriefEntityMapper mapper) : super(mapper);

  @override
  SynchronizableEntity<BriefEntity> createEntity({
    required data,
    required String dataId,
    required String createdAt,
    required String? synchronizedAt,
    required String expirationDate,
  }) {
    return SynchronizableBriefEntity(
      data: data,
      dataId: dataId,
      createdAt: createdAt,
      synchronizedAt: synchronizedAt,
      expirationDate: expirationDate,
    );
  }
}
