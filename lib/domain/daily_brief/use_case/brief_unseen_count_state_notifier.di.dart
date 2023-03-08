import 'dart:async';

import 'package:injectable/injectable.dart';

@lazySingleton
class BriefUnseenCountStateNotifier {
  final StreamController<int> _changeStream = StreamController.broadcast();
  var _unseenCount = 0;

  Stream<int> get stream => _changeStream.stream;

  void notify(int unseenCount) {
    _unseenCount = unseenCount;
    _changeStream.sink.add(_unseenCount);
  }

  void decrease() {
    _unseenCount--;
    _changeStream.sink.add(_unseenCount);
  }

  @disposeMethod
  void dispose() {
    _changeStream.close();
  }
}
