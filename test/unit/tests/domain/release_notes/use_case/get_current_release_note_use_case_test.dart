import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/get_current_release_note_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late MockReleaseNotesRemoteRepository releaseNotesRemoteRepository;
  late MockReleaseNotesLocalRepository releaseNotesLocalRepository;
  late MockAppInfoRepository appInfoRepository;
  late GetCurrentReleaseNoteUseCase useCase;

  setUp(() {
    releaseNotesRemoteRepository = MockReleaseNotesRemoteRepository();
    releaseNotesLocalRepository = MockReleaseNotesLocalRepository();
    appInfoRepository = MockAppInfoRepository();
    useCase = GetCurrentReleaseNoteUseCase(
      releaseNotesRemoteRepository,
      releaseNotesLocalRepository,
      appInfoRepository,
    );
  });

  test(
    'returns existing release note for new app version',
    () async {
      const appVersion = '1.0.0';
      final releaseNote = ReleaseNote(
        headline: 'New cool feature',
        content: 'Here is some more info about the new cool feature',
        date: DateTime(2022, 05, 23),
        media: [],
        version: appVersion,
      );

      when(appInfoRepository.getAppVersion()).thenAnswer((realInvocation) async => appVersion);
      when(releaseNotesLocalRepository.isNewVersion(appVersion)).thenAnswer((realInvocation) async => true);
      when(releaseNotesRemoteRepository.getReleaseNote(appVersion)).thenAnswer((realInvocation) async => releaseNote);

      final actual = await useCase();

      expect(actual, releaseNote);

      verify(releaseNotesLocalRepository.saveVersion(appVersion));
    },
  );

  test(
    'returns null for new app version when release note does not exist',
    () async {
      const appVersion = '1.0.0';
      const ReleaseNote? releaseNote = null;

      when(appInfoRepository.getAppVersion()).thenAnswer((realInvocation) async => appVersion);
      when(releaseNotesLocalRepository.isNewVersion(appVersion)).thenAnswer((realInvocation) async => true);
      when(releaseNotesRemoteRepository.getReleaseNote(appVersion)).thenAnswer((realInvocation) async => releaseNote);

      final actual = await useCase();

      expect(actual, releaseNote);

      verifyNever(releaseNotesLocalRepository.saveVersion(any));
    },
  );

  test(
    'returns null when app version did not change',
    () async {
      const appVersion = '1.0.0';
      const ReleaseNote? releaseNote = null;

      when(appInfoRepository.getAppVersion()).thenAnswer((realInvocation) async => appVersion);
      when(releaseNotesLocalRepository.isNewVersion(appVersion)).thenAnswer((realInvocation) async => false);

      final actual = await useCase();

      expect(actual, releaseNote);

      verifyNever(releaseNotesRemoteRepository.getReleaseNote(any));
    },
  );
}
