abstract class AppLinkDataSource {
  Future<Uri?> getInitialAction();

  Stream<Uri> listenForIncomingActions();

  Future<void> clear();
}
