import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_bar_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicCoverBarCubit extends Cubit<TopicCoverBarState> {
  TopicCoverBarCubit(
    this._getTopicBySlugUseCase,
  ) : super(TopicCoverBarState.idle());

  final GetTopicBySlugUseCase _getTopicBySlugUseCase;

  Future<void> shareTopic(String topicSlug, ShareOptions? options) async {
    emit(TopicCoverBarState.loading());
    final topic = await _getTopicBySlugUseCase(topicSlug);
    emit(TopicCoverBarState.share(topic: topic, options: options));
  }
}
