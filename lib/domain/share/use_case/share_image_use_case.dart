import 'dart:io';

import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareImageUseCase {
  ShareImageUseCase(this._shareRepository);

  final ShareRepository _shareRepository;

  Future<void> call(File image, [String? text]) async {
    return _shareRepository.shareImage(image, text);
  }
}
