import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<bool> call() async => _userRepository.deleteAccount();
}
