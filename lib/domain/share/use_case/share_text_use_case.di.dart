import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareTextUseCase {
  ShareTextUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<void> call(ShareOptions shareOption, String text, [String? subject]) async {
    return _shareRepository.shareText(shareOption, text, subject);
  }
}
