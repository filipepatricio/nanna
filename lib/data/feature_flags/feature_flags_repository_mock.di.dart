import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FeaturesFlagsRepository, env: mockEnvs)
class FeatureFlagsRepositoryMock implements FeaturesFlagsRepository {
  const FeatureFlagsRepositoryMock();

  @override
  Future<void> initialize(
    String uuid,
    String email,
    String firstName,
    String lastName,
    String client,
    String clientVersion,
    String clientPlatform,
  ) async {
    return;
  }

  @override
  Future<String> initialTab() {
    return Future.value('');
  }

  @override
  Future<bool> showArticleRelatedContentSection() {
    return Future.value(true);
  }

  @override
  Future<bool> showArticleMoreFromBriefSection() {
    return Future.value(true);
  }
}
