import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_out_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTokenExpirationStreamUseCase {
  GetTokenExpirationStreamUseCase(this._authRepository, this._signOutUseCase);
  final AuthRepository _authRepository;
  final SignOutUseCase _signOutUseCase;

  Stream<void> call() {
    return _authRepository.tokenExpirationStream().map((event) {
      _signOutUseCase();
      return event;
    });
  }
}
