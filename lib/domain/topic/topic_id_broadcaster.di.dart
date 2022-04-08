import 'dart:async';

import 'package:injectable/injectable.dart';

@singleton
class TopicIdBroadcaster {
  final Map<String, Future<String>> _completerMap = {};

  void addFutureId(String topicSlug, Future<String> future) {
    _completerMap[topicSlug] = future;
  }

  Future<String?> getId(String topicSlug) async {
    final future = _completerMap.remove(topicSlug);

    if (future == null) return null;
    return future;
  }
}
