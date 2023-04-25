abstract class CategoriesLocalRepository {
  Future<bool> isAddInterestsPageSeen(String userUuid);

  Future<void> setAddInterestsPageSeen(String userUuid);

  Future<void> clear(String userUuid);
}
