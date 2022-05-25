import 'package:better_informed_mobile/data/release_notes/api/release_notes_data_source.dart';
import 'package:better_informed_mobile/data/release_notes/dto/release_note_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/release_note_popup.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest('${ReleaseNotePopup}_(no_media)', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<ReleaseNotesDataSource>(
          () => FakeReleaseNotesDataSource(MockDTO.noMediaReleaseNote),
        );
        getIt.registerFactory<ReleaseNotesLocalRepository>(
          () => FakeReleaseNotesLocalRepository(),
        );
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest('${ReleaseNotePopup}_(single_media)', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<ReleaseNotesDataSource>(
          () => FakeReleaseNotesDataSource(MockDTO.singleMediaReleaseNote),
        );
        getIt.registerFactory<ReleaseNotesLocalRepository>(
          () => FakeReleaseNotesLocalRepository(),
        );
      },
    );
    await tester.matchGoldenFile();
  });

  visualTest('${ReleaseNotePopup}_(multiple_media)', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<ReleaseNotesDataSource>(
          () => FakeReleaseNotesDataSource(MockDTO.multipleMediaReleaseNote),
        );
        getIt.registerFactory<ReleaseNotesLocalRepository>(
          () => FakeReleaseNotesLocalRepository(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}

class FakeReleaseNotesDataSource extends Fake implements ReleaseNotesDataSource {
  FakeReleaseNotesDataSource(this.releaseNote);

  final ReleaseNoteDTO releaseNote;

  @override
  Future<ReleaseNoteDTO?> getReleaseNote(String version) async => releaseNote;
}

class FakeReleaseNotesLocalRepository extends Fake implements ReleaseNotesLocalRepository {
  @override
  Future<bool> isNewVersion(String version) async => true;

  @override
  Future<void> saveVersion(String version) async {}

  @override
  Future<List<String>> getAllVersions() async => [];
}
