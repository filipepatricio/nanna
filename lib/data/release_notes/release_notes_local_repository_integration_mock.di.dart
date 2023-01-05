import 'package:better_informed_mobile/data/release_notes/release_notes_local_repository_impl.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReleaseNotesLocalRepository, env: integrationTestEnvs)
class ReleaseNotesLocalRepositoryIntegrationMock extends ReleaseNotesLocalRepositoryImpl {
  ReleaseNotesLocalRepositoryIntegrationMock(super.store);

  @override
  Future<bool> isNewVersion(String version) async {
    return false;
  }
}
