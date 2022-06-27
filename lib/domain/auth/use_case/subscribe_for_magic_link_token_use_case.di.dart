import 'package:better_informed_mobile/domain/auth/app_link/auth_app_link_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscribeForMagicLinkTokenUseCase {
  SubscribeForMagicLinkTokenUseCase(this._authAppLinkRepository);
  final AuthAppLinkRepository _authAppLinkRepository;

  Stream<String> call() {
    return _authAppLinkRepository.subscribeForMagicLinkToken();
  }
}
