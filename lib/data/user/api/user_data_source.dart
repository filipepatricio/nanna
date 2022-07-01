import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';

import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';

abstract class UserDataSource {
  Future<UserDTO> getUser();

  Future<UserDTO> updateUser(UserMetaDTO userMetaDTO);

  Future<void> updatePreferredCategories(List<String> categoryIds);
}
