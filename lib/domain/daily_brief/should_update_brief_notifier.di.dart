import 'dart:async';

import 'package:injectable/injectable.dart';

@singleton
class ShouldUpdateBriefNotifier {
  final StreamController<bool> _changeStream = StreamController.broadcast();

  Stream<bool> get stream => _changeStream.stream;

  void notify() {
    _changeStream.sink.add(true);
  }

  @disposeMethod
  void dispose() {
    _changeStream.close();
  }
}
