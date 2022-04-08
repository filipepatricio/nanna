import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTopicsFromEditorUseCase {
  final TopicsRepository _topicsRepository;

  GetTopicsFromEditorUseCase(this._topicsRepository);

  Future<List<Topic>> call(String editorId) => _topicsRepository.getTopicsFromEditor(editorId);
}
