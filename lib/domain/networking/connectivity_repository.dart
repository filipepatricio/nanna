abstract class ConnectivityRepository {
  Future<bool> hasInternetConnection();

  Stream<bool> get hasInternetConnectionStream;
}
