import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShareOptionsListUseCase {
  GetShareOptionsListUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<List<ShareOptions>> call() => _shareRepository.getShareOptions();
}
