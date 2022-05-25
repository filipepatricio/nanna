abstract class ReleaseNotesLocalRepository {
  Future<bool> isNewVersion(String version);

  Future<void> saveVersion(String version);

  Future<List<String>> getAllVersions();
}
