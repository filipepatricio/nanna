import 'dart:async';

import 'package:better_informed_mobile/domain/article/use_case/get_reading_banner_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const double scrollEnd = 1.0;

@injectable
class ReadingBannerCubit extends Cubit<ReadingBannerState> {
  ReadingBannerCubit(this._getReadingBannerStreamUseCase) : super(ReadingBannerState.notVisible());
  final GetReadingBannerStreamUseCase _getReadingBannerStreamUseCase;

  StreamSubscription? readingBannerStream;

  Future<void> initialize() async {
    readingBannerStream = _getReadingBannerStreamUseCase().listen((readingBanner) {
      if (readingBanner.scrollProgress == scrollEnd) {
        emit(ReadingBannerState.notVisible());
      } else {
        // TODO: Don't show banner until reading progress is tracked server-side
        emit(ReadingBannerState.notVisible());
      }
    });
  }

  @override
  Future<void> close() async {
    await readingBannerStream?.cancel();
    return super.close();
  }
}
