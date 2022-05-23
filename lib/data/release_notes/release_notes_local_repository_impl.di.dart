import 'package:better_informed_mobile/data/release_notes/store/release_notes_store.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReleaseNotesLocalRepository)
class ReleaseNotesLocalRepositoryImpl implements ReleaseNotesLocalRepository {
  ReleaseNotesLocalRepositoryImpl(this._store);

  final ReleaseNotesStore _store;

  @override
  Future<bool> isNewVersion(String version) async {
    final isStored = await _store.hasVersion(version);
    return !isStored;
  }

  @override
  Future<void> saveVersion(String version) async {
    await _store.saveVersion(version);
  }
}
