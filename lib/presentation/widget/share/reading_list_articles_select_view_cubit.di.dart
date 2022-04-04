import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_image_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_reading_list_view.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const articlesSelectionLimit = 3;

@injectable
class ReadingListArticlesSelectViewCubit extends Cubit<ReadingListArticlesSelectViewState> {
  ReadingListArticlesSelectViewCubit(this._shareImageUseCase)
      : super(ReadingListArticlesSelectViewState.initializing());

  final ShareImageUseCase _shareImageUseCase;

  late Topic _topic;
  final Set<int> _selectedIndexes = {};

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

  Future<void> shareImage() async {
    emit(ReadingListArticlesSelectViewState.generatingShareImage());

    final articles =
        _selectedIndexes.map((e) => _topic.readingList.entries[e]).map((e) => e.item as MediaItemArticle).toList();

    final generator = ShareViewImageGenerator(
      () => ShareReadingListView(
        topic: _topic,
        articles: articles,
      ),
    );
    final image = await generateShareImage(generator, '${_topic.id}_share_topic.png');
    await _shareImageUseCase(image, _topic.url);

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
