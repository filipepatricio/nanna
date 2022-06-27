import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserUseCase {
  UpdateUserUseCase(this._userRepository);
  final UserRepository _userRepository;

  Future<User> call(SettingsAccountData settingsAccountData) => _userRepository.updateUser(settingsAccountData);
}
