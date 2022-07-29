import 'package:better_informed_mobile/data/util/audio_progress.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleAudioPositionUseCase {
  const GetArticleAudioPositionUseCase(
    this._audioProgress,
  );

  final AudioProgress _audioProgress;

  double call(MediaItemArticle article) => _audioProgress.getProgress(article: article);
}
