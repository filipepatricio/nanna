import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_out_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTokenExpirationStreamUseCase {
  final AuthRepository _authRepository;
  final SignOutUseCase _signOutUseCase;

  GetTokenExpirationStreamUseCase(this._authRepository, this._signOutUseCase);

  Stream<void> call() {
    return _authRepository.tokenExpirationStream().map((event) {
      _signOutUseCase();
      return event;
    });
  }
}
