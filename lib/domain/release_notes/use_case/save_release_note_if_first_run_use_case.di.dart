import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveReleaseNoteIfFirstRunUseCase {
  SaveReleaseNoteIfFirstRunUseCase(
    this._appInfoRepository,
    this._releaseNotesLocalRepository,
    this._authStore,
  );

  final AppInfoRepository _appInfoRepository;
  final ReleaseNotesLocalRepository _releaseNotesLocalRepository;
  final AuthStore _authStore;

  Future<void> call() async {
    final allReleaseNoteVersions = await _releaseNotesLocalRepository.getAllVersions();
    if (allReleaseNoteVersions.isNotEmpty) return;

    final token = await _authStore.read();
    if (token != null) return;

    final version = await _appInfoRepository.getAppVersion();
    await _releaseNotesLocalRepository.saveVersion(version);
  }
}
