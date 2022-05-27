import 'package:better_informed_mobile/data/release_notes/api/release_notes_data_source.dart';
import 'package:better_informed_mobile/data/release_notes/dto/release_note_dto.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReleaseNotesDataSource, env: mockEnvs)
class ReleaseNotesMockDataSource implements ReleaseNotesDataSource {
  @override
  Future<ReleaseNoteDTO?> getReleaseNote(String version) async {
    return null;
  }
}
