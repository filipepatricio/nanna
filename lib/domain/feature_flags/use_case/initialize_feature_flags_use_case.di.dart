import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/user/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeFeatureFlagsUseCase {
  final AuthStore _authStore;
  final UserRepository _userRepository;
  final FeaturesFlagsRepository _featuresFlagsRepository;

  InitializeFeatureFlagsUseCase(
    this._authStore,
    this._userRepository,
    this._featuresFlagsRepository,
  );

  Future<void> call() async {
    final tokenData = await _authStore.accessTokenData();

    if (tokenData != null) {
      var email = tokenData.email;
      var lastName = tokenData.firstName;
      var firstName = tokenData.lastName;

      if (email == null || firstName == null || lastName == null) {
        final user = await _userRepository.getUser();
        email = user.email;
        firstName = user.firstName;
        lastName = user.lastName;
      }

      await _featuresFlagsRepository.initialize(
        tokenData.uuid,
        email,
        firstName,
        lastName,
      );
    }
  }
}
