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
  int _progress = 0;

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
            interval: const Duration(seconds: 5),
            name: 'reading-progress-tracker',
            timeout: const Duration(seconds: 1),
            task: _trackReadingProgress,
            minCycle: const Duration(seconds: 2),
          );

    _readingProgressTrackingScheduler?.start();
  }

  void setMaxScrollOffset(int? maxScrollOffset) {
    _maxScrollOffset = maxScrollOffset;
  }

  void updateScrollOffset(int scrollOffset) {
    if (_maxScrollOffset != null) {
      _progress = _calculateProgress(scrollOffset, _maxScrollOffset!);
      if (_progress == 100) {
        _trackReadingProgress();
      }
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
      ((currentPosition / maxHeight) * 100).toInt().clamp(0, 100);
}
