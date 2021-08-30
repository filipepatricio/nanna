import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view_state.dart';
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

  Future<void> generateShareImage() async {}

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
