import 'package:better_informed_mobile/data/user/database/entity/user_entity.hv.dart';
import 'package:better_informed_mobile/data/user/database/mapper/user_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_local_repository.dart';
import 'package:hive/hive.dart';

const _userBoxName = 'user';
const _userKey = 'user';

class UserHiveLocalRepository implements UserLocalRepository {
  UserHiveLocalRepository._(this._userBox, this._userEntityMapper);

  final UserEntityMapper _userEntityMapper;
  final LazyBox<UserEntity> _userBox;

  static Future<UserHiveLocalRepository> create(UserEntityMapper userEntityMapper) async {
    final userBox = await Hive.openLazyBox<UserEntity>(_userBoxName);
    return UserHiveLocalRepository._(userBox, userEntityMapper);
  }

  @override
  Future<void> deleteUser() async {
    await _userBox.clear();
  }

  @override
  Future<User?> loadUser() async {
    final userEntity = await _userBox.get(_userKey);
    if (userEntity == null) return null;

    return _userEntityMapper.to(userEntity);
  }

  @override
  Future<void> saveUser(User user) async {
    final userEntity = _userEntityMapper.from(user);
    await _userBox.put(_userKey, userEntity);
  }
}
