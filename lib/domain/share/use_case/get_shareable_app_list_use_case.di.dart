import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShareableAppListUseCase {
  GetShareableAppListUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<List<ShareApp>> call() => _shareRepository.getShareableApps();
}
