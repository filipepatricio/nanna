import 'dart:async';

import 'package:better_informed_mobile/domain/util/image_precache/image_precache_data.dt.dart';
import 'package:injectable/injectable.dart';

@singleton
class ImagePrecacheBroadcaster {
  final _controller = StreamController<ImagePrecacheData>.broadcast();

  Stream<ImagePrecacheData> get stream => _controller.stream;

  void broadcast(ImagePrecacheData data) {
    _controller.add(data);
  }

  @disposeMethod
  void dispose() {
    _controller.close();
  }
}
