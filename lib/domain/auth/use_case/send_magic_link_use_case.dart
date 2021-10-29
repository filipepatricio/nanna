import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendMagicLinkUseCase {
  final AuthRepository _authRepository;

  SendMagicLinkUseCase(this._authRepository);

  Future<void> call(String email) async {
    await _authRepository.requestMagicLink(email);
  }
}
