import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/free_article/free_article_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

@injectable
class FreeArticleViewCubit extends Cubit<FreeArticleViewState> {
  FreeArticleViewCubit(
    this._trackArticleReadingProgressUseCase,
  ) : super(const FreeArticleViewState.idle());

  final TrackArticleReadingProgressUseCase _trackArticleReadingProgressUseCase;

  int? _maxScrollOffset;
  int _progress = 1;

  late final MediaItemArticle _article;
  UpdateArticleProgressResponse? _updateArticleProgressResponse;

  UpdateArticleProgressResponse? get updateArticleProgressResponse => _updateArticleProgressResponse;

  NeatPeriodicTaskScheduler? _readingProgressTrackingScheduler;

  void init(
    MediaItemArticle article,
  ) {
    _article = article;
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
    final updateArticleProgressResponse = await _trackArticleReadingProgressUseCase(_article, _progress);
    _updateArticleProgressResponse = updateArticleProgressResponse;
  }

  @override
  Future<void> close() {
    _readingProgressTrackingScheduler?.stop();
    return super.close();
  }

  int _calculateProgress(int currentPosition, int maxHeight) =>
      ((currentPosition / maxHeight) * 100).toInt().clamp(1, 100);
}
