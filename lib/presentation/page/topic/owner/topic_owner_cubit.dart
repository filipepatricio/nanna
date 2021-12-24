import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topics_from_expert_use_case.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicOwnerPageCubit extends Cubit<TopicOwnerPageState> {
  final GetTopicsFromExpertUseCase _getTopicsFromExpertUseCase;

  TopicOwnerPageCubit(this._getTopicsFromExpertUseCase) : super(TopicOwnerPageState.loading());

  late List<Topic> _topicsFromExpert;

  Future<void> initialize([String? expertId]) async {
    if (expertId == null) {
      emit(TopicOwnerPageState.idleEditor());
      return;
    }

    emit(TopicOwnerPageState.loading());

    try {
      _topicsFromExpert = await _getTopicsFromExpertUseCase.call(expertId);
      emit(TopicOwnerPageState.idleExpert(_topicsFromExpert));
    } catch (e, s) {
      Fimber.e('Fetching expert topics failed', ex: e, stacktrace: s);
      emit(TopicOwnerPageState.error());
    }
  }
}
