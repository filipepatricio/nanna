import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/networking/connectivity_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ConnectivityRepository, env: mockEnvs)
class ConnectivityRepositoryMock implements ConnectivityRepository {
  @override
  Future<bool> hasInternetConnection() async {
    return true;
  }

  @override
  Stream<bool> get hasInternetConnectionStream async* {
    yield true;
  }
}
