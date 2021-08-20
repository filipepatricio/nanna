import 'dart:async';

import 'package:better_informed_mobile/domain/article/use_case/get_reading_banner_use_case.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const double scrollEnd = 1.0;

@injectable
class ReadingBannerCubit extends Cubit<ReadingBannerState> {
  final GetReadingBannerStreamUseCase _getReadingBannerStreamUseCase;

  ReadingBannerCubit(this._getReadingBannerStreamUseCase) : super(ReadingBannerState.notVisible());

  StreamSubscription? readingBannerStream;

  Future<void> initialize() async {
    readingBannerStream = _getReadingBannerStreamUseCase.call().listen((readingBanner) {
      if (readingBanner.scrollProgress == scrollEnd) {
        emit(ReadingBannerState.notVisible());
      } else {
        emit(ReadingBannerState.visible(readingBanner));
      }
    });
  }

  @override
  Future<void> close() async {
    await readingBannerStream?.cancel();
    return super.close();
  }
}
