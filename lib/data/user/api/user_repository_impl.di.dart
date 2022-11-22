import 'package:better_informed_mobile/data/categories/mapper/category_preference_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/mapper/user_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this._dataSource,
    this._userDTOMapper,
    this._categoryPreferenceDTOMapper,
  );
  final UserDataSource _dataSource;
  final UserDTOMapper _userDTOMapper;
  final CategoryPreferenceDTOMapper _categoryPreferenceDTOMapper;

  @override
  Future<User> getUser() async {
    final dto = await _dataSource.getUser();
    return _userDTOMapper.to(dto);
  }

  @override
  Future<User> updateUser(SettingsAccountData settingsAccountData) async {
    final userMetaDto = UserMetaDTO(settingsAccountData.firstName, settingsAccountData.lastName);
    final dto = await _dataSource.updateUser(userMetaDto);
    return _userDTOMapper.to(dto);
  }

  @override
  Future<List<CategoryPreference>> getCategoryPreferences() async {
    final dto = await _dataSource.getCategoryPreferences();
    return dto.map<CategoryPreference>(_categoryPreferenceDTOMapper).toList();
  }

  @override
  Future<bool> updatePreferredCategories(List<Category> categories) async {
    final categoryIds = categories.map<String>((category) => category.id).toList();
    return (await _dataSource.updatePreferredCategories(categoryIds)).successful;
  }

  @override
  Future<bool> deleteAccount() async {
    return (await _dataSource.deleteAccount()).successful;
  }

  @override
  Future<bool> followCategory(Category category) async {
    return (await _dataSource.followCategory(category.id)).successful;
  }

  @override
  Future<bool> unfollowCategory(Category category) async {
    return (await _dataSource.unfollowCategory(category.id)).successful;
  }

  @override
  Future<CategoryPreference> getCategoryPreference(Category category) async {
    final dto = await _dataSource.getCategoryPreference(category.id);
    return _categoryPreferenceDTOMapper(dto);
  }
}
