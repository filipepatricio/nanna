import 'package:better_informed_mobile/domain/permissions/permissions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class HasNotificationPermissionUseCase {
  HasNotificationPermissionUseCase(this._permissionsRepository);
  final PermissionsRepository _permissionsRepository;

  Future<bool> call() => _permissionsRepository.getPermissionStatus(Permission.notification).isGranted;
}
