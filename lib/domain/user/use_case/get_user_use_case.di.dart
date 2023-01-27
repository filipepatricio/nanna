import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_local_repository.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase {
  GetUserUseCase(
    this._userRepository,
    this._userLocalRepository,
  );

  final UserRepository _userRepository;
  final UserLocalRepository _userLocalRepository;

  Future<User> call() async {
    try {
      final user = await _userRepository.getUser();
      await _userLocalRepository.saveUser(user);

      return user;
    } on NoInternetConnectionException {
      final user = await _userLocalRepository.loadUser();
      if (user == null) rethrow;

      return user;
    }
  }
}
