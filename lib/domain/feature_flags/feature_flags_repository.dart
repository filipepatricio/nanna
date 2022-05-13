abstract class FeaturesFlagsRepository {
  Future<void> initialize(
    String uuid,
    String email,
    String firstName,
    String lastName,
    String client,
    String clientVersion,
    String clientPlatform,
  );

  Future<bool> showPhotoOnTopicCover();

  Future<bool> showPillsOnExplorePage();

  Future<bool> showSearchInExplorePage();

  Future<String> initialTab();
}
