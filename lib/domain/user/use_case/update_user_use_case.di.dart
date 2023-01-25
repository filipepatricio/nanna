import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_local_repository.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserUseCase {
  UpdateUserUseCase(
    this._userRepository,
    this._userLocalRepository,
  );

  final UserRepository _userRepository;
  final UserLocalRepository _userLocalRepository;

  Future<User> call(SettingsAccountData settingsAccountData) async {
    final user = await _userRepository.updateUser(settingsAccountData);
    await _userLocalRepository.saveUser(user);

    return user;
  }
}
