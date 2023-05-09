import 'dart:async';

import 'package:injectable/injectable.dart';

@lazySingleton
class ShouldRefreshPageNotifier {
  final StreamController<bool> _changeStream = StreamController.broadcast();

  Stream<bool> get stream => _changeStream.stream;

  void notify() {
    if (!_changeStream.isClosed) {
      _changeStream.sink.add(true);
    }
  }

  @disposeMethod
  void dispose() {
    _changeStream.close();
  }
}
