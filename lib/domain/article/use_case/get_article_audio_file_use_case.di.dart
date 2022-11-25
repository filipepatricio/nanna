import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleAudioFileUseCase {
  GetArticleAudioFileUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<AudioFile> call(String articleSlug) {
    return _articleRepository.getArticleAudioFile(articleSlug);
  }
}
