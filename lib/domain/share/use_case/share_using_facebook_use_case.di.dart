import 'dart:io';

import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareUsingFacebookUseCase {
  ShareUsingFacebookUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<void> call(File foregroundFile, String url) async {
    return _shareRepository.shareFacebookStory(foregroundFile, url);
  }
}
