abstract class ReleaseNotesStore {
  Future<void> saveVersion(String version);

  Future<bool> hasVersion(String version);

  Future<List<String>> getAllVersions();
}
