import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserUseCase {
  final UserRepository _userRepository;

  UpdateUserUseCase(this._userRepository);

  Future<User> call(SettingsAccountData settingsAccountData) => _userRepository.updateUser(settingsAccountData);
}
