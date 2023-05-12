import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/permissions/permissions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@LazySingleton(as: PermissionsRepository, env: testEnvs)
class PermissionsRepositoryMock implements PermissionsRepository {
  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission> permissions) {
    return Future<Map<Permission, PermissionStatus>>.value({
      Permission.notification: PermissionStatus.granted,
      Permission.appTrackingTransparency: PermissionStatus.granted
    });
  }

  @override
  Future<PermissionStatus> getPermissionStatus(Permission permission) {
    return Future.value(PermissionStatus.granted);
  }

  @override
  Future<PermissionStatus> requestPermission(Permission permission) {
    return Future.value(PermissionStatus.granted);
  }
}
