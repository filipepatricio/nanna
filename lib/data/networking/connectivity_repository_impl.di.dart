import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/networking/connectivity_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ConnectivityRepository, env: liveEnvs)
class ConnectivityRepositoryImpl implements ConnectivityRepository {
  @override
  Future<bool> hasInternetConnection() async {
    final connection = await Connectivity().checkConnectivity();
    return _isValidConnection(connection);
  }

  @override
  Stream<bool> get hasInternetConnectionStream => Connectivity().onConnectivityChanged.map(
        (connection) => _isValidConnection(connection),
      );

  bool _isValidConnection(ConnectivityResult connection) {
    if (connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }
}
