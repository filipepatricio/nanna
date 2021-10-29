import 'package:better_informed_mobile/domain/auth/app_link/auth_app_link_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscribeForMagicLinkTokenUseCase {
  final AuthAppLinkRepository _authAppLinkRepository;

  SubscribeForMagicLinkTokenUseCase(this._authAppLinkRepository);

  Stream<String> call() {
    return _authAppLinkRepository.subscribeForMagicLinkToken();
  }
}
