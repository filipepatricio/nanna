import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_image_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic/share_topic_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const articlesSelectionLimit = 3;

@injectable
class TopicArticlesSelectViewCubit extends Cubit<TopicArticlesSelectViewState> {
  TopicArticlesSelectViewCubit(
    this._shareImageUseCase,
    this._shareViewImageGenerator,
  ) : super(TopicArticlesSelectViewState.initializing());

  final ShareImageUseCase _shareImageUseCase;
  final ShareViewImageGenerator _shareViewImageGenerator;

  late Topic _topic;
  final Set<int> _selectedIndexes = {};

  Future<void> initialize(Topic topic) async {
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
    emit(TopicArticlesSelectViewState.generatingShareImage());

    final articles = _selectedIndexes.map((e) => _topic.entries[e]).map((e) => e.item as MediaItemArticle).toList();

    ShareTopicView factory() => ShareTopicView(
          topic: _topic,
          articles: articles,
        );
    final image = await generateShareImage(
      _shareViewImageGenerator,
      factory,
      '${_topic.id}_share_topic.png',
    );
    await _shareImageUseCase(
      image,
      _topic.url,
      _topic.strippedTitle,
    );

    emit(TopicArticlesSelectViewState.shared());
  }

  void _emitIdleState() {
    emit(
      TopicArticlesSelectViewState.idle(
        _canSelectMore(),
        _topic.entries.map((entry) => entry.item).whereType<MediaItemArticle>().toList(),
        Set.from(_selectedIndexes),
        articlesSelectionLimit,
      ),
    );
  }

  bool _canSelectMore() => _selectedIndexes.length < articlesSelectionLimit;
}
