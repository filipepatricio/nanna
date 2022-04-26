abstract class FeaturesFlagsRepository {
  Future<void> initialize(String uuid, String email, String firstName, String lastName);

  Future<bool> showPhotoOnTopicCover();
}
