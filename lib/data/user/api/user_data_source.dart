import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/category_preference_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';

abstract class UserDataSource {
  Future<UserDTO> getUser();

  Future<UserDTO> updateUser(UserMetaDTO userMetaDTO);

  Future<SuccessfulResponseDTO> updatePreferredCategories(List<String> categoryIds);

  Future<List<CategoryPreferenceDTO>> getCategoryPreferences();

  Future<SuccessfulResponseDTO> deleteAccount();

  Future<SuccessfulResponseDTO> followCategory(String id);

  Future<SuccessfulResponseDTO> unfollowCategory(String id);

  Future<CategoryPreferenceDTO> getCategoryPreference(String id);
}
