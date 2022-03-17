import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAppVersionUseCase {
  GetAppVersionUseCase(this._appInfoRepository);

  final AppInfoRepository _appInfoRepository;

  Future<String> call() => _appInfoRepository.getAppVersion();
}
