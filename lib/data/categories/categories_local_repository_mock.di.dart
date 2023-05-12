import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/categories/categories_local_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CategoriesLocalRepository, env: mockEnvs)
class CategoriesLocalRepositoryMock implements CategoriesLocalRepository {
  @override
  Future<void> clear(String userUuid) async {}

  @override
  Future<bool> isAddInterestsPageSeen(String userUuid) async => true;

  @override
  Future<void> setAddInterestsPageSeen(String userUuid) async {}
}
