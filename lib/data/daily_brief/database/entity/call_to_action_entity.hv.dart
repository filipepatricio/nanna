import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'call_to_action_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.callToActionEntity)
class CallToActionEntity {
  CallToActionEntity({
    required this.preText,
    required this.actionText,
  });

  @HiveField(0)
  final String? preText;
  @HiveField(1)
  final String actionText;
}
