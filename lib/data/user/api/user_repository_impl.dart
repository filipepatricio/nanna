import 'package:better_informed_mobile/data/user/api/mapper/user_dto_mapper.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserDataSource _dataSource;
  final UserDTOMapper _userDTOMapper;

  UserRepositoryImpl(
    this._dataSource,
    this._userDTOMapper,
  );

  @override
  Future<User> getUser() async {
    final dto = await _dataSource.getUser();
    return _userDTOMapper.to(dto);
  }
}
