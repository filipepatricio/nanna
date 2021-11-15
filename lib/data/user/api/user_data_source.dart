import 'package:better_informed_mobile/data/user/api/dto/user_dto.dart';

import 'dto/user_meta_dto.dart';

abstract class UserDataSource {
  Future<UserDTO> getUser();

  Future<UserDTO> updateUser(UserMetaDTO userMetaDTO);
}
