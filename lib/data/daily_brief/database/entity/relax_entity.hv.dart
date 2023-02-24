import 'package:better_informed_mobile/data/daily_brief/database/entity/call_to_action_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'relax_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.relaxEntity)
class RelaxEntity {
  RelaxEntity({
    required this.headline,
    required this.message,
    required this.icon,
    required this.callToAction,
  });

  @HiveField(0)
  final String headline;
  @HiveField(1)
  final String message;
  @HiveField(2)
  final String? icon;
  @HiveField(3)
  final CallToActionEntity? callToAction;
}
