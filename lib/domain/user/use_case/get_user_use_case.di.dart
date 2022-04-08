import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  Future<User> call() => _userRepository.getUser();
}
