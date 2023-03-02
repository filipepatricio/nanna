import 'dart:async';

import 'package:injectable/injectable.dart';

@lazySingleton
class ShouldShowDailyBriefBadgeStateNotifier {
  final StreamController<bool> _changeStream = StreamController.broadcast();

  Stream<bool> get stream => _changeStream.stream;

  void notify(bool shouldShowBadge) {
    _changeStream.sink.add(shouldShowBadge);
  }

  @disposeMethod
  void dispose() {
    _changeStream.close();
  }
}
