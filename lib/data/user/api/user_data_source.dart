import 'package:better_informed_mobile/data/user/api/dto/user_dto.dart';

abstract class UserDataSource {
  Future<UserDTO> getUser();
}
