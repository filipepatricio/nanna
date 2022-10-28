import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShareOptionsListUseCase {
  GetShareOptionsListUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<List<ShareOption>> call() => _shareRepository.getShareOptions();
}
