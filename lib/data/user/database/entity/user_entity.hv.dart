import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'user_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.userEntity)
class UserEntity {
  UserEntity({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @HiveField(0)
  final String uuid;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  @HiveField(3)
  final String email;
}
