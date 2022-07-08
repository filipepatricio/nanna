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

  Future<String> initialTab();

  Future<bool> showArticleRelatedContentSection();

  Future<bool> showArticleMoreFromBriefSection();

  Future<bool> showArticleMoreFromTopic();
}
