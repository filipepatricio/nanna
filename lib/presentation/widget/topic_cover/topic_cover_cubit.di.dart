import 'package:better_informed_mobile/domain/feature_flags/use_case/show_header_image_on_topic_cover_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicCoverCubit extends Cubit<TopicCoverState> {
  TopicCoverCubit(this._showPhotoOnTopicCoverUseCase) : super(TopicCoverState.loading());

  final ShowPhotoOnTopicCoverUseCase _showPhotoOnTopicCoverUseCase;

  Future<void> initialize() async {
    final showPhoto = await _showPhotoOnTopicCoverUseCase();
    emit(TopicCoverState.idle(showPhoto: showPhoto));
  }
}
