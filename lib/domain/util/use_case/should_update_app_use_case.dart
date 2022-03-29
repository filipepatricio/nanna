import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShouldUpdateAppUseCase {
  ShouldUpdateAppUseCase(this._appInfoRepository);

  final AppInfoRepository _appInfoRepository;

  Future<bool> call() => _appInfoRepository.shouldUpdate();
}
