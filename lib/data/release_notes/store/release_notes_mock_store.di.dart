import 'package:better_informed_mobile/data/release_notes/store/release_notes_store.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReleaseNotesStore, env: mockEnvs)
class ReleaseNotesMockStore implements ReleaseNotesStore {
  @override
  Future<bool> hasVersion(String version) async {
    return true;
  }

  @override
  Future<void> saveVersion(String version) async {}

  @override
  Future<List<String>> getAllVersions() async => [];
}
