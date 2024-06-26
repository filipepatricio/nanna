import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/category_preference_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserDataSource, env: mockEnvs)
class UserMockDataSource implements UserDataSource {
  UserMockDataSource() {
    _user = User(uuid: '1', firstName: 'User', lastName: 'Test', email: 'test@betterinformed.io');
  }
  User? _user;

  @override
  Future<UserDTO> getUser() async {
    final userDTO = _user != null ? UserDTO(_user!.uuid, _user!.firstName, _user!.lastName, _user!.email) : null;
    return userDTO ?? (throw Exception('User can not be null'));
  }

  @override
  Future<UserDTO> updateUser(UserMetaDTO userMetaDto) async {
    if (_user != null) {
      _user = User(
        uuid: _user!.uuid,
        email: _user!.email,
        firstName: userMetaDto.firstName ?? _user!.firstName,
        lastName: userMetaDto.lastName ?? _user!.lastName,
      );
    }
    return _user != null
        ? UserDTO(_user!.uuid, _user!.firstName, _user!.lastName, _user!.email)
        : (throw Exception('User can not be null'));
  }

  @override
  Future<SuccessfulResponseDTO> updatePreferredCategories(List<String> categoryIds) async =>
      SuccessfulResponseDTO(true);

  @override
  Future<List<CategoryPreferenceDTO>> getCategoryPreferences() async => MockDTO.categoryPreferences;

  @override
  Future<SuccessfulResponseDTO> deleteAccount() async => SuccessfulResponseDTO(true);

  @override
  Future<CategoryPreferenceDTO> followCategory(String slug) async => MockDTO.categoryPreference;

  @override
  Future<CategoryPreferenceDTO> unfollowCategory(String slug) async => MockDTO.categoryPreference;

  @override
  Future<CategoryPreferenceDTO> getCategoryPreference(String id) async => MockDTO.categoryPreference;
}
