import 'package:better_informed_mobile/domain/daily_brief/daily_brief_entry_seen_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:injectable/injectable.dart';

const _expirationTime = Duration(days: 1);

@injectable
class SaveSeenEntryLocallyUseCase {
  SaveSeenEntryLocallyUseCase(
    this._dailyBriefItemSeenLocalRepository,
    this._saveSynchronizableItemUseCase,
  );

  final DailyBriefEntrySeenLocalRepository _dailyBriefItemSeenLocalRepository;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;

  Future<void> call(BriefEntry entry) async {
    final seenItem = BriefEntrySeen.fromEntry(entry);

    final synchronizable = Synchronizable.createNotSynchronized<BriefEntrySeen>(
      seenItem.slug,
      _expirationTime,
      seenItem,
    );
    await _saveSynchronizableItemUseCase(_dailyBriefItemSeenLocalRepository, synchronizable);
  }
}
