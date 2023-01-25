import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/user/database/entity/user_entity.hv.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserEntityMapper implements BidirectionalMapper<UserEntity, User> {
  @override
  UserEntity from(User data) {
    return UserEntity(
      uuid: data.uuid,
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
    );
  }

  @override
  User to(UserEntity data) {
    return User(
      uuid: data.uuid,
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
    );
  }
}
