import 'package:permission_handler/permission_handler.dart';

abstract class PermissionsRepository {
  Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission> permissions);

  Future<PermissionStatus> requestPermission(Permission permission);

  Future<PermissionStatus> getPermissionStatus(Permission permission);
}
