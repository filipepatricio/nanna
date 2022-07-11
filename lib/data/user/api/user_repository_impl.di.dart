import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/mapper/user_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dataSource, this._userDTOMapper);
  final UserDataSource _dataSource;
  final UserDTOMapper _userDTOMapper;

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
  Future<void> updatePreferredCategories(List<Category> categories) {
    final categoryIds = categories.map<String>((category) => category.id).toList();
    return _dataSource.updatePreferredCategories(categoryIds);
  }

  @override
  Future<bool> deleteAccount() async {
    return (await _dataSource.deleteAccount()).successful;
  }
}
