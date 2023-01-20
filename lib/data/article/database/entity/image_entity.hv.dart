import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'image_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.imageEntity)
class ImageEntity {
  ImageEntity({
    required this.publicId,
    required this.caption,
  });

  @HiveField(0)
  final String publicId;
  @HiveField(1)
  final String? caption;
}
