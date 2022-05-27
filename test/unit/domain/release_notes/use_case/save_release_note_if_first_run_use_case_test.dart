import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/save_release_note_if_first_run_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late MockAppInfoRepository appInfoRepository;
  late MockReleaseNotesLocalRepository releaseNotesLocalRepository;
  late MockAuthStore authStore;
  late SaveReleaseNoteIfFirstRunUseCase useCase;

  setUp(() {
    appInfoRepository = MockAppInfoRepository();
    releaseNotesLocalRepository = MockReleaseNotesLocalRepository();
    authStore = MockAuthStore();
    useCase = SaveReleaseNoteIfFirstRunUseCase(
      appInfoRepository,
      releaseNotesLocalRepository,
      authStore,
    );
  });

  test('do nothing when user already seen some release notes', () async {
    when(releaseNotesLocalRepository.getAllVersions()).thenAnswer((realInvocation) async => ['1.0.0']);

    await useCase();

    verifyNever(releaseNotesLocalRepository.saveVersion(any));
  });

  test('do nothing when user is already signed in', () async {
    final token = AuthToken(accessToken: 'accessToken', refreshToken: 'refreshToken');

    when(releaseNotesLocalRepository.getAllVersions()).thenAnswer((realInvocation) async => []);
    when(authStore.read()).thenAnswer((realInvocation) async => token);

    await useCase();

    verifyNever(releaseNotesLocalRepository.saveVersion(any));
  });

  test('save current version when user is not logged in and has not seen any release notes', () async {
    const appVersion = '1.0.0';

    when(releaseNotesLocalRepository.getAllVersions()).thenAnswer((realInvocation) async => []);
    when(authStore.read()).thenAnswer((realInvocation) async => null);
    when(appInfoRepository.getAppVersion()).thenAnswer((realInvocation) async => appVersion);

    await useCase();

    verify(releaseNotesLocalRepository.saveVersion(appVersion));
  });
}
