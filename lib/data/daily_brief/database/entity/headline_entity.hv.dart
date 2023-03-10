import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'headline_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.headlineEntity)
class HeadlineEntity {
  HeadlineEntity({
    required this.headline,
    required this.message,
    required this.icon,
  });

  @HiveField(0)
  final String headline;
  @HiveField(1)
  final String? message;
  @HiveField(2)
  final String? icon;
}
