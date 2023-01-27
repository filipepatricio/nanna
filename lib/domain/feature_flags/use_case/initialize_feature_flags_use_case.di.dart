import 'package:better_informed_mobile/data/feature_flags/data/feature_flag_data.dt.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeFeatureFlagsUseCase {
  InitializeFeatureFlagsUseCase(
    this._authStore,
    this._featuresFlagsRepository,
    this._appInfoRepository,
    this._getUserUseCase,
  );
  final AuthStore _authStore;
  final FeaturesFlagsRepository _featuresFlagsRepository;
  final AppInfoRepository _appInfoRepository;
  final GetUserUseCase _getUserUseCase;

  Future<void> call() async {
    final tokenData = await _authStore.accessTokenData();

    if (tokenData != null) {
      var email = tokenData.email;
      var lastName = tokenData.firstName;
      var firstName = tokenData.lastName;

      if (email == null || firstName == null || lastName == null) {
        final user = await _getUserUseCase();
        email = user.email;
        firstName = user.firstName;
        lastName = user.lastName;
      }

      const client = 'app';
      final clientVersion = await _appInfoRepository.getAppVersion();
      final clientPlatform = _appInfoRepository.getPlatform();

      await _featuresFlagsRepository.initialize(
        FeatureFlagData(
          uuid: tokenData.uuid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          client: client,
          clientVersion: clientVersion,
          clientPlatform: clientPlatform,
        ),
      );
    }
  }
}
