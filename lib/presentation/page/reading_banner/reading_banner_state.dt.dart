import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_banner_state.dt.freezed.dart';

@freezed
class ReadingBannerState with _$ReadingBannerState {
  @Implements<BuildState>()
  factory ReadingBannerState.notVisible() = _ReadingBannerStateNotVisible;

  @Implements<BuildState>()
  factory ReadingBannerState.visible(ReadingBanner readingBanner) = _ReadingBannerStateVisible;
}
