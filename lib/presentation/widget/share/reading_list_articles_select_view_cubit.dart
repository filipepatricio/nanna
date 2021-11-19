import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view_state.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_reading_list_view.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

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

    final articles =
        _selectedIndexes.map((e) => _topic.readingList.entries[e]).map((e) => e.item as MediaItemArticle).toList();

    final generator = ShareViewImageGenerator(
      () => ShareReadingListView(
        topic: _topic,
        articles: articles,
      ),
    );
    await shareImage(generator, '${_topic.id}_share_topic.png', _topic.title);

    emit(ReadingListArticlesSelectViewState.shared());
  }

  void _emitIdleState() {
    emit(
      ReadingListArticlesSelectViewState.idle(
        _canSelectMore(),
        _topic.readingList.entries.map((entry) => entry.item).whereType<MediaItemArticle>().toList(),
        Set.from(_selectedIndexes),
        articlesSelectionLimit,
      ),
    );
  }

  bool _canSelectMore() => _selectedIndexes.length < articlesSelectionLimit;
}
