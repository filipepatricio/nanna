import 'package:better_informed_mobile/domain/topic/data/curator.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topics_from_editor_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topics_from_expert_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicOwnerPageCubit extends Cubit<TopicOwnerPageState> {
  TopicOwnerPageCubit(
    this._getTopicsFromExpertUseCase,
    this._getTopicsFromEditorUseCase,
  ) : super(TopicOwnerPageState.loading());
  final GetTopicsFromExpertUseCase _getTopicsFromExpertUseCase;
  final GetTopicsFromEditorUseCase _getTopicsFromEditorUseCase;

  Future<void> initialize(Curator owner, [String? fromTopicSlug]) async {
    if (owner is EditorialTeam) {
      emit(TopicOwnerPageState.idleEditorialTeam());
      return;
    }

    emit(TopicOwnerPageState.loading());

    try {
      if (owner is Expert) {
        emit(
          TopicOwnerPageState.idleExpert(await _getTopicsFromExpertUseCase.call(owner.id, fromTopicSlug)),
        );
        return;
      }

      emit(
        TopicOwnerPageState.idleEditor(await _getTopicsFromEditorUseCase.call(owner.id, fromTopicSlug)),
      );
      return;
    } catch (e, s) {
      Fimber.e('Fetching ${owner.runtimeType} topics failed', ex: e, stacktrace: s);
      emit(TopicOwnerPageState.error());
    }
  }

  Future<void> openSocialMediaLink(String link) async {
    await openInAppBrowser(
      link,
      (_, __) {
        final previousState = state;
        emit(TopicOwnerPageState.browserError(link));
        emit(previousState);
      },
    );
  }
}
