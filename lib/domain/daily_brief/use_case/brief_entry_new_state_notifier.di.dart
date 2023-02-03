import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BriefEntryNewStateNotifier {
  final StreamController<BriefEntry> _changeStream = StreamController.broadcast();
  final Map<String, BriefEntry> _briefEntries = {};

  Stream<BriefEntry> get stream async* {
    for (final entry in _briefEntries.values) {
      yield entry;
    }

    yield* _changeStream.stream;
  }

  void notify(BriefEntry entry) {
    _briefEntries[entry.id] = entry;
    _changeStream.sink.add(entry);
  }

  @disposeMethod
  void dispose() {
    _briefEntries.clear();
    _changeStream.close();
  }
}
