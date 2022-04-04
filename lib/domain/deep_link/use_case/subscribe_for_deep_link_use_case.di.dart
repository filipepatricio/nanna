import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscribeForDeepLinkUseCase {
  final DeepLinkRepository _deepLinkRepository;

  SubscribeForDeepLinkUseCase(this._deepLinkRepository);

  Stream<String> call() {
    return _deepLinkRepository.subscribeForDeepLink();
  }
}
