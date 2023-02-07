import 'dart:async';

import 'package:better_informed_mobile/domain/util/image_precache/image_precache_broadcaster.di.dart';
import 'package:better_informed_mobile/domain/util/image_precache/image_precache_data.dt.dart';
import 'package:better_informed_mobile/presentation/widget/image_precaching_view/image_precaching_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImagePrecachingViewCubit extends Cubit<ImagePrecachingViewState> {
  ImagePrecachingViewCubit(this._broadcaster) : super(const ImagePrecachingViewState.initial());

  final ImagePrecacheBroadcaster _broadcaster;

  StreamSubscription<ImagePrecacheData>? _subscription;

  Future<void> initialize() async {
    _subscription = _broadcaster.stream.listen((data) {
      data.map(
        article: (data) => emit(ImagePrecachingViewState.article(data.article)),
        topic: (data) => emit(
          ImagePrecachingViewState.topic(data.topic),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
