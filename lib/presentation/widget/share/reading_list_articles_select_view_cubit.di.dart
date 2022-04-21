import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_image_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_reading_list_view.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

const articlesSelectionLimit = 3;

@injectable
class ReadingListArticlesSelectViewCubit extends Cubit<ReadingListArticlesSelectViewState> {
  ReadingListArticlesSelectViewCubit(
    this._shareImageUseCase,
    this._getTopicBySlugUseCase,
  ) : super(ReadingListArticlesSelectViewState.initializing());

  final ShareImageUseCase _shareImageUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;

  late Topic _topic;
  final Set<int> _selectedIndexes = {};

  Future<void> initialize(Topic? topic, TopicPreview? preview) async {
    throwIf(
      topic == null && preview == null,
      Exception('At least one value needs to exist'),
    );

    if (preview != null) {
      _topic = await _getTopicBySlugUseCase(preview.slug);
    } else if (topic != null) {
      _topic = topic;
    }

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

  Future<void> shareImage(GetIt getIt) async {
    emit(ReadingListArticlesSelectViewState.generatingShareImage());

    final articles =
        _selectedIndexes.map((e) => _topic.readingList.entries[e]).map((e) => e.item as MediaItemArticle).toList();

    final generator = ShareViewImageGenerator(
      () => ShareReadingListView(
        topic: _topic,
        articles: articles,
        getIt: getIt,
      ),
    );
    final image = await generateShareImage(generator, '${_topic.id}_share_topic.png');
    await _shareImageUseCase(
      image,
      _topic.url,
      _topic.strippedTitle,
    );

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
