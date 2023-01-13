import 'package:better_informed_mobile/data/release_notes/store/release_notes_store.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _boxName = 'releaseNotesBox';

@LazySingleton(as: ReleaseNotesStore, env: defaultEnvs)
class ReleaseNotesHiveStore implements ReleaseNotesStore {
  @override
  Future<bool> hasVersion(String version) async {
    final box = await Hive.openBox<String>(_boxName);
    return box.values.any((element) => element == version);
  }

  @override
  Future<void> saveVersion(String version) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.add(version);
  }

  @override
  Future<List<String>> getAllVersions() async {
    final box = await Hive.openBox<String>(_boxName);
    return box.values.toList(growable: false);
  }
}
