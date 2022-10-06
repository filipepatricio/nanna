import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/free_article/free_article_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

@injectable
class FreeArticleViewCubit extends Cubit<FreeArticleViewState> {
  FreeArticleViewCubit(this._trackArticleReadingProgressUseCase) : super(const FreeArticleViewState.idle());

  final TrackArticleReadingProgressUseCase _trackArticleReadingProgressUseCase;

  int? _maxScrollOffset;
  int _progress = 1;

  late final String _articleSlug;
  ArticleProgress? _articleProgress;

  ArticleProgress? get articleProgress => _articleProgress;

  NeatPeriodicTaskScheduler? _readingProgressTrackingScheduler;

  void init(
    String articleSlug,
  ) {
    _articleSlug = articleSlug;
    _setupReadingProgressTracker();
  }

  void _setupReadingProgressTracker() {
    _readingProgressTrackingScheduler = kIsTest
        ? null
        : NeatPeriodicTaskScheduler(
            interval: const Duration(seconds: 3),
            name: 'reading-progress-tracker-free',
            timeout: const Duration(milliseconds: 1500),
            task: _trackReadingProgress,
            minCycle: const Duration(milliseconds: 1500),
          );

    _readingProgressTrackingScheduler?.start();
  }

  void setMaxScrollOffset(int? maxScrollOffset) {
    if ((maxScrollOffset ?? 0) > 0) {
      _maxScrollOffset = maxScrollOffset;
    }
  }

  void updateScrollOffset(int scrollOffset) {
    if (_maxScrollOffset != null) {
      _progress = _calculateProgress(scrollOffset, _maxScrollOffset!);
    }
  }

  Future<void> _trackReadingProgress() async {
    _articleProgress = await _trackArticleReadingProgressUseCase(_articleSlug, _progress);
  }

  @override
  Future<void> close() {
    _readingProgressTrackingScheduler?.stop();
    return super.close();
  }

  int _calculateProgress(int currentPosition, int maxHeight) =>
      ((currentPosition / maxHeight) * 100).toInt().clamp(1, 100);
}
