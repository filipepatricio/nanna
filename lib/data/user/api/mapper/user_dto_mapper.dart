import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserDTOMapper implements BidirectionalMapper<UserDTO, User> {
  @override
  UserDTO from(User data) {
    return UserDTO(
      data.uuid,
      data.firstName,
      data.lastName,
      data.email,
    );
  }

  @override
  User to(UserDTO data) {
    return User(
      uuid: data.uuid,
      firstName: data.firstName ?? '',
      lastName: data.lastName ?? '',
      email: data.email,
    );
  }
}
