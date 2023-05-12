import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/permissions/permissions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@LazySingleton(as: PermissionsRepository, env: liveEnvs)
class PermissionsRepositoryImpl implements PermissionsRepository {
  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission> permissions) async {
    return await permissions.request();
  }

  @override
  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return await permission.status;
  }

  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }
}
