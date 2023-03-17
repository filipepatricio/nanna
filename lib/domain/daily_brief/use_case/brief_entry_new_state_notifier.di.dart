import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BriefEntryNewStateNotifier {
  final StreamController<BriefEntrySeen> _changeStream = StreamController.broadcast();
  final Map<String, BriefEntrySeen> _briefEntries = {};

  Stream<BriefEntrySeen> get stream async* {
    for (final entry in _briefEntries.values) {
      yield entry;
    }

    yield* _changeStream.stream;
  }

  void notify(BriefEntrySeen entry) {
    _briefEntries[entry.slug] = entry;
    _changeStream.sink.add(entry);
  }

  @disposeMethod
  void dispose() {
    _briefEntries.clear();
    _changeStream.close();
  }
}
