import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendMagicLinkUseCase {
  SendMagicLinkUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<void> call(String email) async {
    await _authRepository.requestMagicLink(email);
  }
}
