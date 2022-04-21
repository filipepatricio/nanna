import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
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
    final authToken = await _authStore.read();
    if (authToken != null) {
      final tokenData = authToken.accessToken.decoded();

      final uuid = tokenData['sub'] as String?;
      var email = tokenData['email'] as String?;
      var lastName = tokenData['family_name'] as String?;
      var firstName = tokenData['given_name'] as String?;

      if (uuid != null) {
        if (email == null || firstName == null || lastName == null) {
          final user = await _userRepository.getUser();
          email = user.email;
          firstName = user.firstName;
          lastName = user.lastName;
        }

        await _featuresFlagsRepository.initialize(
          uuid,
          email,
          firstName,
          lastName,
        );
      }
    }
  }
}
