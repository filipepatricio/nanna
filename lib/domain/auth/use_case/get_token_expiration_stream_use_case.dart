import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTokenExpirationStreamUseCase {
  final AuthRepository _authRepository;

  GetTokenExpirationStreamUseCase(this._authRepository);

  Stream<void> call() => _authRepository.tokenExpirationStream();
}
