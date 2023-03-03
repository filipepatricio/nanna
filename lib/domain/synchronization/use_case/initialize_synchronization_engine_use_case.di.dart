import 'package:better_informed_mobile/domain/article/use_case/broadcast_stored_read_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/resync_images_for_stored_articles_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/run_initial_bookmark_sync_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_all_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeSynchronizationEngineUseCase {
  InitializeSynchronizationEngineUseCase(
    this._runIntitialBookmarkSyncUseCase,
    this._synchronizeAllUseCase,
    this._broadcastStoredReadProgressUseCase,
    this._resyncImagesForStoredArticlesUseCase,
  );

  final RunIntitialBookmarkSyncUseCase _runIntitialBookmarkSyncUseCase;
  final SynchronizeAllUseCase _synchronizeAllUseCase;
  final BroadcastStoredReadProgressUseCase _broadcastStoredReadProgressUseCase;
  final ResyncImagesForStoredArticlesUseCase _resyncImagesForStoredArticlesUseCase;

  Future<void> call() async {
    await _runIntitialBookmarkSyncUseCase();
    await _synchronizeAllUseCase();
    await _broadcastStoredReadProgressUseCase();
    await _resyncImagesForStoredArticlesUseCase();
  }
}
