abstract class AppLinkDataSource {
  Future<String?> getInitialAction();

  Stream<String> listenForIncomingActions();

  Future<void> clear();
}
