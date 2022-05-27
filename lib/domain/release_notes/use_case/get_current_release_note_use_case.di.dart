import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_remote_repository.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentReleaseNoteUseCase {
  GetCurrentReleaseNoteUseCase(
    this._releaseNotesRemoteRepository,
    this._releaseNotesLocalRepository,
    this._appInfoRepository,
  );

  final ReleaseNotesRemoteRepository _releaseNotesRemoteRepository;
  final ReleaseNotesLocalRepository _releaseNotesLocalRepository;
  final AppInfoRepository _appInfoRepository;

  Future<ReleaseNote?> call() async {
    final appVersion = await _appInfoRepository.getAppVersion();
    final isNewVersion = await _releaseNotesLocalRepository.isNewVersion(appVersion);

    if (isNewVersion) {
      final releaseNote = await _releaseNotesRemoteRepository.getReleaseNote(appVersion);

      if (releaseNote != null) {
        await _releaseNotesLocalRepository.saveVersion(appVersion);
      }

      return releaseNote;
    }

    return null;
  }
}
