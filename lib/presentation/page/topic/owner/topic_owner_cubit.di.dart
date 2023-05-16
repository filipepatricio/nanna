import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topics_from_editor_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topics_from_expert_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
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
    this._isGuestModeUseCase,
  ) : super(TopicOwnerPageState.loading());

  final GetTopicsFromExpertUseCase _getTopicsFromExpertUseCase;
  final GetTopicsFromEditorUseCase _getTopicsFromEditorUseCase;
  final IsGuestModeUseCase _isGuestModeUseCase;

  Future<void> initialize(Curator curator, [String? fromTopicSlug]) async {
    emit(TopicOwnerPageState.loading());

    try {
      final isGuestMode = await _isGuestModeUseCase();

      await curator.map(
        editor: (_) async {
          final topics =
              isGuestMode ? <TopicPreview>[] : await _getTopicsFromEditorUseCase.call(curator.id, fromTopicSlug);
          emit(TopicOwnerPageState.idleEditor(topics));
        },
        expert: (_) async {
          final topics =
              isGuestMode ? <TopicPreview>[] : await _getTopicsFromExpertUseCase.call(curator.id, fromTopicSlug);
          emit(TopicOwnerPageState.idleExpert(topics));
        },
        editorialTeam: (_) async {
          emit(TopicOwnerPageState.idleEditorialTeam());
        },
        unknown: (_) async => emit(TopicOwnerPageState.error()),
      );
    } catch (e, s) {
      Fimber.e('Fetching ${curator.runtimeType} topics failed', ex: e, stacktrace: s);
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
