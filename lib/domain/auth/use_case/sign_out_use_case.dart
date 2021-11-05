import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignOutUseCase {
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;

  SignOutUseCase(this._authStore, this._analyticsRepository);

  Future<void> call() async {
    await _authStore.delete();
    await _analyticsRepository.logout();
  }
}
