import 'dart:io';

import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareUsingInstagramUseCase {
  ShareUsingInstagramUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<void> call(File foregroundFile, File? backgroundFile, String url) async {
    return _shareRepository.shareUsingInstagram(foregroundFile, backgroundFile, url);
  }
}
