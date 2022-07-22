import 'dart:io';

import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareImageUseCase {
  ShareImageUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<void> call(ShareApp shareApp, File image, [String? text, String? subject]) async {
    return _shareRepository.shareImage(shareApp, image, text, subject);
  }
}
