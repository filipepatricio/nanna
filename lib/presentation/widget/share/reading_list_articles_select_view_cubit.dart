import 'dart:io';

import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view_state.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_topic_view.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

const articlesSelectionLimit = 3;

@injectable
class ReadingListArticlesSelectViewCubit extends Cubit<ReadingListArticlesSelectViewState> {
  late Topic _topic;
  final Set<int> _selectedIndexes = {};

  ReadingListArticlesSelectViewCubit() : super(ReadingListArticlesSelectViewState.initializing());

  void initialize(Topic topic) {
    _topic = topic;

    _emitIdleState();
  }

  void selectArticle(int index) {
    _selectedIndexes.add(index);

    _emitIdleState();
  }

  void unselectArticle(int index) {
    _selectedIndexes.remove(index);

    _emitIdleState();
  }

  Future<void> generateShareImage() async {
    emit(ReadingListArticlesSelectViewState.generatingShareImage());

    final generator = ShareViewImageGenerator(() => ShareTopicView(topic: _topic, articles: []));
    final imageBytes = await generator.generate();

    if (imageBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final shareImagePath = join(tempDir.path, '${_topic.id}_share_topic.png');
      final file = File(shareImagePath);
      await file.writeAsBytes(imageBytes.buffer.asInt8List());

      await Share.shareFiles([file.path]);
    }

    emit(ReadingListArticlesSelectViewState.shared());
  }

  void _emitIdleState() {
    emit(
      ReadingListArticlesSelectViewState.idle(
        _canSelectMore(),
        _topic.readingList.articles,
        Set.from(_selectedIndexes),
        articlesSelectionLimit,
      ),
    );
  }

  bool _canSelectMore() => _selectedIndexes.length < articlesSelectionLimit;
}
