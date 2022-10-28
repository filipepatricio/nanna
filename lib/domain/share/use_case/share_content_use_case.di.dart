import 'package:better_informed_mobile/domain/share/data/share_content.dt.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareContentUseCase {
  ShareContentUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<void> call(ShareContent content) async {
    await content.map(
      facebook: (content) => _shareRepository.shareFacebookStory(
        content.foregroundFile,
        content.url,
      ),
      instagram: (content) => _shareRepository.shareUsingInstagram(
        content.foregroundFile,
        content.backgroundFile,
        content.url,
      ),
      text: (content) => _shareRepository.shareText(
        content.shareOption,
        content.text,
        content.subject,
      ),
      image: (content) => _shareRepository.shareImage(
        content.shareOption,
        content.image,
        content.subject,
      ),
    );
  }
}
