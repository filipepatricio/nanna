import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareTextUseCase {
  ShareTextUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<void> call(String text) async {
    return _shareRepository.shareText(text);
  }
}
