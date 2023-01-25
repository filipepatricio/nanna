import 'package:better_informed_mobile/data/article/database/entity/image_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'publisher_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.publisherEntity)
class PublisherEntity {
  PublisherEntity({
    required this.name,
    required this.darkLogo,
    required this.lightLogo,
  });

  @HiveField(0)
  final String name;
  @HiveField(1)
  final ImageEntity? darkLogo;
  @HiveField(2)
  final ImageEntity? lightLogo;
}
