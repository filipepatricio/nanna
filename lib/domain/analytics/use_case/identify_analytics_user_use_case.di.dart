import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class IdentifyAnalyticsUserUseCase {
  IdentifyAnalyticsUserUseCase(
    this._authStore,
    this._analyticsRepository,
  );
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;

  Future<void> call([String? method]) async {
    final tokenData = await _authStore.accessTokenData();

    if (tokenData != null) {
      await _analyticsRepository.identify(tokenData.uuid, method);
    }
  }
}
